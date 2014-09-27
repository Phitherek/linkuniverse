class LinkCollection < ActiveRecord::Base
  belongs_to :parent, class_name: "LinkCollection"
  has_many :children, class_name: "LinkCollection"
  has_many :links
  belongs_to :user
  has_and_belongs_to_many :viewers, class_name: "User"
  
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
