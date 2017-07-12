class LinkCollection < ActiveRecord::Base
  belongs_to :parent, class_name: "LinkCollection"
  has_many :children, class_name: "LinkCollection", dependent: :destroy, foreign_key: :parent_id
  has_many :links, foreign_key: :collection_id, dependent: :destroy
  belongs_to :user
  has_many :link_collection_memberships, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  
  validates :name, presence: true, uniqueness: { scope: :user, message: "should be unique for user" }
  validates :user_id, presence: true
  
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

  def permission_for(user)
    if user == self.user
      return 'owner'
    end
    if pub?
      permission = 'view'
    else
      permission = nil
    end
    permission_for_user = link_collection_memberships.where(user: user).first.try(:permission)
    if permission_for_user.present?
      better_permission(permission, permission_for_user)
    else
      if parent.present?
        parent_permission_for_user = parent.permission_for(user)
      else
        parent_permission_for_user = nil
      end
      better_permission(permission, parent_permission_for_user)
    end
  end

  def descriptive_permission_for(user)
    case permission_for(user)
    when nil
      'None'
    when 'view'
      'View'
    when 'vote'
      'View, Vote'
    when 'comment'
      'View, Vote, Comment'
    when 'edit'
      'View, Vote, Comment, Edit'
    when 'owner'
      'Owner'
    end
  end

  def link_handle
    id.to_s + '-' + name.parameterize
  end

  private

  def better_permission(p1, p2)
    if p2.present?
      case p2
      when 'view'
        if %w(vote comment edit).include?(p1)
          p1
        else
          p2
        end
      when 'vote'
        if %w(comment edit).include?(p1)
          p1
        else
          p2
        end
      when 'comment'
        if p1 == 'edit'
          p1
        else
          p2
        end
      when 'edit'
        p2
      end
    else
      p1
    end
  end
end
