class LinkCollectionMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :link_collection

  validates :user_id, presence: true, uniqueness: { scope: :link_collection }
  validates :link_collection_id, presence: true
  validates :permission, inclusion: { in: %w(view vote comment edit) }
end
