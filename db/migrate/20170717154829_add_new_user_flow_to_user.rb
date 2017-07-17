class AddNewUserFlowToUser < ActiveRecord::Migration
  def change
    add_column :users, :active, :boolean, null: false, default: false
    add_column :users, :activation_token, :string, null: false, default: ''
    add_column :users, :password_reset_used, :boolean, null: false, default: true
    add_column :users, :password_reset_token, :string, null: false, default: ''
  end
end
