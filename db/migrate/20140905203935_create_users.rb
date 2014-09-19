class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :null => true, :default => nil
      t.string :email
      t.text :description, :null => true, :default => nil
      t.string :hashed_password, :null => true
      t.string :salt, :null => true
      t.timestamps
    end
  end
end
