class CollectionsController < ApplicationController
  def index
    if current_user.nil?
      @collections = LinkCollection.pub.toplevel.limit(9)
    else
      @own_collections = current_user.collections.toplevel.limit(9)
      @viewable_collections = current_user.viewable_collections.toplevel.limit(9)
      @public_collections = LinkCollection.pub.toplevel.limit(9)
    end
    add_breadcrumb 'Home'
  end

  def new
    add_breadcrumb 'Home', root_path
    add_breadcrumb 'New collection'
  end
end
