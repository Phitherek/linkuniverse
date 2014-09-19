class CreateLinkCollections < ActiveRecord::Migration
  def change
    create_table :link_collections do |t|
      t.string :name
      t.boolean :pub, :null => false, :default => false
      t.belongs_to :user
      t.timestamps
    end
    
    create_table :link_collections_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :link_collection
    end
  end
end
