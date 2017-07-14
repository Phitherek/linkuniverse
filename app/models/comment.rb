class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: true
  validates :user_id, presence: true
  validates :commentable_id, presence: true

  default_scope -> { order(created_at: :asc) }
end
