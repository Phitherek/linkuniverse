class AddParentToLinkCollections < ActiveRecord::Migration
  def change
    add_column :link_collections, :parent_id, :integer, :default => nil
  end
end
