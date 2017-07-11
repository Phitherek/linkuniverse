class User < ActiveRecord::Base
  has_many :collections, class_name: "LinkCollection"
  has_and_belongs_to_many :viewable_collections, class_name: "LinkCollection"
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  scope :like, ->(q) {where("UPPER(username) LIKE UPPER('%#{q}%') OR UPPER(email) LIKE UPPER('%#{q}%')")}

  def self.find_by_username_or_email(key)
    User.where("email = ? OR username = ?", key, key).first
  end

end
