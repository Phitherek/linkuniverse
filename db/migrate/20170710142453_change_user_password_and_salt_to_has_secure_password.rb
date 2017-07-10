class ChangeUserPasswordAndSaltToHasSecurePassword < ActiveRecord::Migration
  def change
    remove_column :users, :salt
    remove_column :users, :hashed_password
    add_column :users, :password_digest, :string, null: false, default: ''
  end
end
