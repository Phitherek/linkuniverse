class CollectionsController < ApplicationController
  before_action :find_collection, only: [:edit, :update, :destroy]

  def index
    if current_user.nil?
      @collections = LinkCollection.pub.toplevel.limit(9).to_a
    else
      @own_collections = current_user.collections.unscoped.toplevel.limit(9).to_a
      @viewable_collections = current_user.viewable_collections.select { |c| c.parent == nil }.first(9)
      @public_collections = LinkCollection.pub.toplevel.limit(9).to_a
    end
    add_breadcrumb 'Home'
  end

  def own

  end

  def shared

  end

  def public

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
      elsif @collection.permission_for(current_user).present?
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
