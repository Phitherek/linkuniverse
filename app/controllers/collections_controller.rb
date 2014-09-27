class CollectionsController < ApplicationController
    def index
        @user = current_user
        if @user.nil?
            @collections = LinkCollection.pub.toplevel
        else
            @collections = @user.collections.toplevel
            @collections.merge(@user.viewable_collections.toplevel)
            @collections.merge(LinkCollection.pub.toplevel)
            @collections.uniq!
        end
    end
end
