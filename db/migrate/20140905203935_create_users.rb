class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :null, :default => nil
      t.string :email
      t.text :description, :null, :default => nil
      t.string :hashed_password, :null
      t.string :salt, :null
      t.timestamps
    end
  end
end
