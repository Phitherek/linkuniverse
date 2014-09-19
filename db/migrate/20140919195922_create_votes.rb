class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :user
      t.belongs_to :link
      t.boolean :positive, :null => false, :default => true
      t.timestamps
    end
  end
end
