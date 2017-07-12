class CreateLinkCollectionMemberships < ActiveRecord::Migration
  def change
    create_table :link_collection_memberships do |t|
      t.belongs_to :user
      t.belongs_to :link_collection
      t.string :permission, null: false, default: 'view'
      t.boolean :active, null: false, default: false
      t.timestamps
    end
  end
end
