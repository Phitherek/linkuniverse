class User < ActiveRecord::Base
  has_many :collections, class_name: "LinkCollection", dependent: :destroy
  has_many :link_collection_memberships, dependent: :destroy
  has_many :links, dependent: :destroy
  has_secure_password
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  before_create :generate_activation_token
  after_create :send_activation_email

  validates :email, presence: true, uniqueness: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :activation_token, uniqueness: { allow_blank: true }
  validates :password_reset_token, uniqueness: { allow_blank: true }

  scope :like, ->(q) {where("UPPER(username) LIKE UPPER(?) OR UPPER(email) LIKE UPPER(?)", "%#{q}%", "%#{q}%",)}
  scope :active, -> {where(active: true)}
  scope :inactive, -> {where(active: false)}
  scope :with_password_reset, -> {where(password_reset_used: false)}

  def self.find_by_username_or_email(key)
    User.where("email = ? OR username = ?", key, key).first
  end

  def viewable_collections(filter = nil)
    memberships = link_collection_memberships.joins(:link_collection).where(active: true).where.not(permission: nil)
    memberships = memberships.where("UPPER(link_collections.name) LIKE UPPER(?)", "%#{filter}%") if filter
    memberships.collect { |m| m.link_collection }
  end

  def start_password_reset
    generate_password_reset_token
    self.password_reset_used = false
    save
  end

  def generate_password_reset_token
    self.password_reset_token = loop do
      token = SecureRandom.urlsafe_base64(nil, false)
      break token unless User.exists?(password_reset_token: token)
    end
  end

  def send_activation_email
    SystemMailer.activation_email(self).deliver
  end

  def generate_activation_token
    self.activation_token = loop do
      token = SecureRandom.urlsafe_base64(nil, false)
      break token unless User.exists?(activation_token: token)
    end
  end

end
