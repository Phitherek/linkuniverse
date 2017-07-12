class MakeVotesAndCommentsUniversal < ActiveRecord::Migration
  def change
    remove_column :votes, :link_id
    remove_column :comments, :link_id
    add_column :votes, :voteable_id, :integer
    add_column :votes, :voteable_type, :string
    add_column :comments, :commentable_id, :integer
    add_column :comments, :commentable_type, :string
  end
end
