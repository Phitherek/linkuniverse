class Link < ActiveRecord::Base
  belongs_to :collection, class_name: "LinkCollection"
  has_many :comments
  
  before_save :ensure_correct_url, :ensure_title
  
  def fetch_title!
    t = nil
    if HTTParty.head(self.url).content_type == "text/html"
      HTTParty.get(self.url).lines.each do |line|
        if line.include?("<title")
          t = line
          t.gsub!(/<\/?title[A-z0-9"= -]*>/, "").chomp!
          break
        end
      end
    end
    self.title = t if !t.nil? && !t.empty?
  end
  
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
