class Link < ActiveRecord::Base
  belongs_to :collection, class_name: "LinkCollection"
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :destroy
  
  before_save :ensure_correct_url, :ensure_title
  
  validates :url, uniqueness: { scope: :collection, message: "should be unique inside collection" }
  validates :title, uniqueness: { scope: :collection, message: "should be unique inside collection" }
  validates :collection_id, presence: true
  validates :user_id, presence: true
  
  scope :like, ->(q) { where("UPPER(title) LIKE UPPER(?) OR UPPER(url) LIKE UPPER(?)", "%#{q}%", "%#{q}%") }
  
  def fetch_title!
    t = nil
    begin
      if HTTParty.head(self.url).content_type == "text/html"
        HTTParty.get(self.url).lines.each do |line|
          /(<title[^>]*>|<TITLE[^>]*>)(.*)(<\/title>|<\/TITLE>)/.match(line) do |md|
            t = md[2] if t.blank?
          end
        end
      end
    rescue
      t = nil
    end
    self.title = t if !t.nil? && !t.empty?
  end

  def score
    votes.positive.count - votes.negative.count
  end

  private
  
  def ensure_title
    if self.title.nil? || self.title.empty?
      self.fetch_title!
      if self.title.nil? || self.title.empty?
        self.title = self.url
      end
    end
  end
  
  def ensure_correct_url
    HTTParty.head(self.url)
  end
end
