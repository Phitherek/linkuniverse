class AddUserIdToLink < ActiveRecord::Migration
  def change
    add_column :links, :user_id, :integer, null: false
  end
end
