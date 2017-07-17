class CollectionsController < ApplicationController
  before_action :find_collection, only: [:edit, :update, :destroy, :upvote, :downvote, :add_participant, :update_participant, :destroy_participant, :cancel_participation]
  before_action :require_current_user, except: [:index, :public, :show, :public_list]

  def index
    if current_user.nil?
      @collections = LinkCollection.pub.toplevel.limit(9).to_a
    else
      @own_collections = current_user.collections.toplevel.limit(9).order(updated_at: :desc).to_a
      @viewable_collections = current_user.viewable_collections.select { |c| c.parent == nil }.sort { |c1, c2| c2.updated_at <=> c1.updated_at }.first(9)
      @public_collections = LinkCollection.pub.toplevel.order(updated_at: :desc).limit(9).to_a
    end
    add_breadcrumb 'Home'
  end

  def own
    @own_collections = current_user.collections.toplevel.order(updated_at: :desc)
    @own_collections = @own_collections.like(params[:filter]) if params[:filter]
    @own_collections = @own_collections.to_a
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Your collections'
  end

  def shared
    @viewable_collections = current_user.viewable_collections(params[:filter]).select { |c| c.parent == nil }.sort { |c1, c2| c2.updated_at <=> c1.updated_at }
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Collections shared with you'
  end

  def public
    @public_collections = LinkCollection.pub.toplevel.order(updated_at: :desc)
    @public_collections = @public_collections.like(params[:filter]) if params[:filter]
    @public_collections = @public_collections.to_a
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Public collections'
  end

  def own_list
    @own_collections = current_user.collections.toplevel.order(updated_at: :desc)
    @own_collections = @own_collections.like(params[:filter]) if params[:filter]
    @own_collections = @own_collections.to_a
    render layout: false
  end

  def shared_list
    @viewable_collections = current_user.viewable_collections(params[:filter]).select { |c| c.parent == nil }.sort { |c1, c2| c2.updated_at <=> c1.updated_at }
    render layout: false
  end

  def public_list
    @public_collections = LinkCollection.pub.toplevel.order(updated_at: :desc)
    @public_collections = @public_collections.like(params[:filter]) if params[:filter]
    @public_collections = @public_collections.to_a
    render layout: false
  end

  def new
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'New collection'
    @collection = LinkCollection.new
    @existing_collections = current_user.collections.unscoped
  end

  def create
    params[:link_collection][:user_id] = current_user.id
    @collection = LinkCollection.create(collection_params)
    if @collection.persisted?
      flash[:notice] = 'Successfully created new collection!'
      redirect_to collection_url(@collection.link_handle)
    else
      flash[:error] = "Could not create new collection: #{@collection.errors.full_messages.join(', ')}!"
      redirect_to new_collection_url
    end
  end

  def show
    add_breadcrumb 'Home', root_path
    id = params[:id].split('-')[0].to_i
    begin
      @collection = LinkCollection.unscoped.find(id)
      if current_user.blank?
        if @collection.pub?
          add_breadcrumb 'Public collections', public_collections_path
          add_breadcrumb @collection.name
        else
          render_error :forbidden
        end
      elsif @collection.user == current_user
        add_breadcrumb 'Your collections', own_collections_path
        add_breadcrumb @collection.name
      elsif @collection.link_collection_memberships.where(user: current_user).any?
        add_breadcrumb 'Collections shared with you', shared_collections_path
        add_breadcrumb @collection.name
      elsif @collection.pub?
        add_breadcrumb 'Public collections',public_collections_path
        add_breadcrumb @collection.name
      else
        render_error :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render_error :notfound
    end
  end

  def edit
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'Your collections', own_collections_path
    add_breadcrumb @collection.name, collection_path(@collection.link_handle)
    add_breadcrumb 'Edit'
    @existing_collections = current_user.collections.unscoped.where.not(id: @collection.id)
  end

  def update
    params[:link_collection][:user_id] = current_user.id
    if @collection.update(collection_params)
      flash[:notice] = 'Collection updated successfully!'
      redirect_to collection_url(@collection.link_handle)
    else
      flash[:error] = "Could not update collection: #{@collection.errors.full_messages.join(',')}"
      redirect_to edit_collection_url(@collection)
    end
  end

  def destroy
    if @collection.destroy
      flash[:success] = 'Collection deleted successfully!'
    else
      flash[:error] = 'Could not delete collection!'
    end
    redirect_to own_collections_url
  end

  def upvote
    if %w(vote comment edit owner).include?(@collection.permission_for(current_user))
      @vote = Vote.find_by(voteable: @collection, user: current_user)
      if @vote.present?
        if @vote.positive?
          @vote.destroy
        else
          @vote.positivize!
        end
      else
        @vote = Vote.create(voteable: @collection, user: current_user, positive: true)
      end
    end
    render layout: false
  end

  def downvote
    if %w(vote comment edit owner).include?(@collection.permission_for(current_user))
      @vote = Vote.find_by(voteable: @collection, user: current_user)
      if @vote.present?
        if @vote.negative?
          @vote.destroy
        else
          @vote.negativize!
        end
      else
        @vote = Vote.create(voteable: @collection, user: current_user, positive: false)
      end
    end
    render layout: false
  end

  def add_participant
    if @collection.user == current_user
      @user = User.find_by_username_or_email(params[:user_key])
      if @user != current_user
        @membership = @collection.link_collection_memberships.create(user: @user, permission: params[:permission])
        @collection.reload
      end
    end
    render layout: false
  end

  def update_participant
    begin
      if @collection.user == current_user
        @membership = @collection.link_collection_memberships.find(params[:membership_id])
        @membership.update(permission: params[:permission])
        @collection.reload
      end
      render layout: false
    rescue ActiveRecord::RecordNotFound
      render layout: false
    end
  end

  def destroy_participant
    begin
      if @collection.user == current_user
        @membership = @collection.link_collection_memberships.find(params[:membership_id])
        @membership.destroy
        @collection.reload
      end
      render layout: false
    rescue ActiveRecord::RecordNotFound
      render layout: false
    end
  end

  def cancel_participation
    m = @collection.link_collection_memberships.where(user: current_user).first
    if m.try(:destroy)
      flash[:notice] = 'Membership in collection cancelled successfully! You have to get invited again to regain it.'
      redirect_to shared_collections_url
    else
      flash[:error] = 'Could not cancel membership in collection!'
      redirect_to collection_url(@collection.link_handle)
    end
  end

  private

  def collection_params
    params.require(:link_collection).permit(:name, :description, :parent_id, :pub, :user_id)
  end

  def find_collection
    begin
      @collection = current_user.collections.unscoped.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error :notfound
    end
  end
end
