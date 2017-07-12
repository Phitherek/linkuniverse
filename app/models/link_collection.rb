class LinkCollection < ActiveRecord::Base
  belongs_to :parent, class_name: "LinkCollection"
  has_many :children, class_name: "LinkCollection", dependent: :destroy
  has_many :links, dependent: :destroy
  belongs_to :user
  has_many :link_collection_memberships, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  
  validates :name, presence: true, uniqueness: { scope: :user, message: "should be unique for user" }
  
  default_scope { where(pub: false) }
  scope :pub, -> { unscoped.where(pub: true) }
  scope :like, ->(q) { where("UPPER(name) LIKE UPPER('%#{q}%')") }
  scope :toplevel, -> { where(parent: nil) }
  
  def pub!
    self.pub = true
    self.save!
  end
  
  def unpub!
    self.pub = false
    self.save!
  end
  
  def pub?
     self.pub
  end
end
