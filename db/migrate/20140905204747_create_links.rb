class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.text :description
      t.string :url, :null => false
      t.belongs_to :collection
      t.timestamps
    end
  end
end
