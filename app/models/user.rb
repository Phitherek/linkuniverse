class User < ActiveRecord::Base
  has_many :collections, class_name: "LinkCollection", dependent: :destroy
  has_many :link_collection_memberships, dependent: :destroy
  has_many :links, dependent: :destroy
  has_secure_password
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  scope :like, ->(q) {where("UPPER(username) LIKE UPPER('%#{q}%') OR UPPER(email) LIKE UPPER('%#{q}%')")}

  def self.find_by_username_or_email(key)
    User.where("email = ? OR username = ?", key, key).first
  end

  def viewable_collections
    link_collection_memberships.where(active: true).where.not(permission: nil).collect { |m| m.link_collection }
  end

end
