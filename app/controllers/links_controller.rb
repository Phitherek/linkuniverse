class LinksController < ApplicationController
  before_action :require_current_user, except: :show
  before_action :find_collection
  before_action :find_link, except: [:new, :create, :title_on_the_fly]

  def new
    render_error :forbidden unless @collection.user == current_user || @collection.permission_for(current_user) == 'edit'
    add_breadcrumb 'Home', root_path
    if @collection.user == current_user
      add_breadcrumb 'Your collections', own_collections_path
      add_breadcrumb @collection.name, collection_url(@collection.link_handle)
    elsif @collection.permission_for(current_user) == 'edit'
      add_breadcrumb 'Collections shared with you', shared_collections_path
      add_breadcrumb @collection.name, collection_path(@collection.link_handle)
    else
      render_error :forbidden
    end
    add_breadcrumb 'Add link'
    @link = @collection.links.new
  end

  def create
    render_error :forbidden unless @collection.user == current_user || @collection.permission_for(current_user) == 'edit'
    params[:link][:user_id] = current_user.id
    @link = @collection.links.create(link_params)
    if @link.persisted?
      flash[:notice] = 'Link created successfully!'
      @collection.touch
      redirect_to collection_url(@collection.link_handle)
    else
      flash[:error] = "Could not create link: #{@link.errors.full_messages.join(', ')}"
      redirect_to new_collection_link_url(@collection.link_handle)
    end
  end

  def show
    add_breadcrumb 'Home', root_path
    if @collection.user == current_user
      add_breadcrumb 'Your collections', own_collections_path
      add_breadcrumb @collection.name, collection_path(@collection.link_handle)
    elsif @collection.permission_for(current_user) == 'edit'
      add_breadcrumb 'Collections shared with you', shared_collections_path
      add_breadcrumb @collection.name, collection_path(@collection.link_handle)
    else
      render_error :forbidden
    end
    add_breadcrumb @link.title
  end

  def edit
    render_error :forbidden unless current_user == @link.user || current_user == @link.collection.user
    add_breadcrumb 'Home', root_path
    if @collection.user == current_user
      add_breadcrumb 'Your collections', own_collections_path
      add_breadcrumb @collection.name, collection_path(@collection.link_handle)
    elsif @collection.permission_for(current_user) == 'edit'
      add_breadcrumb 'Collections shared with you', shared_collections_path
      add_breadcrumb @collection.name, collection_path(@collection.link_handle)
    end
    add_breadcrumb @link.title, collection_link_path(@collection.link_handle, @link.id)
    add_breadcrumb 'Edit'
  end

  def update
    render_error :forbidden unless current_user == @link.user || current_user == @link.collection.user
    if @link.update(link_params)
      flash[:notice] = 'Link updated successfully!'
      @collection.touch
      redirect_to collection_link_url(@collection.link_handle, @link.id)
    else
      flash[:notice] = "Could not update link: #{@link.errors.full_messages.join(',')}!"
      redirect_to edit_collection_link_url(@collection.link_handle, @link.id)
    end
  end

  def destroy
    render_error :forbidden unless current_user == @link.user || current_user == @link.collection.user
    if @link.destroy
      flash[:notice] = 'Link deleted successfully!'
    else
      flash[:error] = 'Could not delete link!'
    end
    redirect_to collection_url(@collection.link_handle)
  end

  def upvote
    if @collection.user == current_user || @link.user == current_user || %w(vote comment edit owner).include?(@collection.permission_for(current_user))
      @vote = Vote.find_by(voteable: @link, user: current_user)
      if @vote.present?
        if @vote.positive?
          @vote.destroy
        else
          @vote.positivize!
        end
      else
        @vote = Vote.create(voteable: @link, user: current_user, positive: true)
      end
    end
    render layout: false
  end

  def downvote
    if @collection.user == current_user || @link.user == current_user || %w(vote comment edit owner).include?(@collection.permission_for(current_user))
      @vote = Vote.find_by(voteable: @link, user: current_user)
      if @vote.present?
        if @vote.negative?
          @vote.destroy
        else
          @vote.negativize!
        end
      else
        @vote = Vote.create(voteable: @link, user: current_user, positive: false)
      end
    end
    render layout: false
  end

  def add_comment
    if @link.user == current_user || @link.collection.user == current_user || %w(comment edit owner).include?(@link.collection.permission_for(current_user))
      @comment = @link.comments.create(user: current_user, content: params[:content])
    end
    render layout: false
  end

  def edit_comment
    begin
      @comment = @link.comments.find(params[:comment_id])
      if @comment.user == current_user || @link.user == current_user || @link.collection.user == current_user
        render layout: false
      else
        render :cancel_edit_comment, layout: false
      end
    rescue ActiveRecord::RecordNotFound
      render nothing: true
    end
  end

  def cancel_edit_comment
    begin
      @comment = @link.comments.find(params[:comment_id])
      render layout: false
    rescue ActiveRecord::RecordNotFound
      render nothing: true
    end
  end

  def update_comment
    begin
      @comment = @link.comments.find(params[:comment_id])
      if @comment.user == current_user || @link.user == current_user || @link.collection.user == current_user
        @comment.update(content: params[:content])
      end
      render layout: false
    rescue ActiveRecord::RecordNotFound
      render layout: false
    end
  end

  def destroy_comment
    begin
      @comment = @link.comments.find(params[:comment_id])
      if @comment.user == current_user || @link.user == current_user || @link.collection.user == current_user
        @comment.destroy
      end
      render layout: false
    rescue ActiveRecord::RecordNotFound
      render layout: false
    end
  end

  def title_on_the_fly
    tmp_link = Link.new(url: params[:link_url])
    tmp_link.fetch_title!
    if tmp_link.title.present?
      render text: tmp_link.title
    else
      render text: tmp_link.url
    end
  end

  def comment_count
    render layout: false
  end

  private

  def link_params
    params.require(:link).permit(:user_id, :title, :url, :description)
  end

  def find_collection
    collection_id = params[:collection_id].split('-')[0].to_i
    begin
      @collection = LinkCollection.unscoped.find(collection_id)
    rescue ActiveRecord::RecordNotFound
      render_error :notfound
    end
  end

  def find_link
    begin
      @link = @collection.links.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_error :notfound
    end
  end
end
