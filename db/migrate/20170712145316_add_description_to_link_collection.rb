class AddDescriptionToLinkCollection < ActiveRecord::Migration
  def change
    add_column :link_collections, :description, :text
  end
end
