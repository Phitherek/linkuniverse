class Vote < ActiveRecord::Base
  belongs_to :link
  belongs_to :user
  
  scope :positive, -> { where(positive: true) }
  scope :negative, -> { where(positive: false) }
  
  def positive?
    self.positive
  end
  
  def negative?
    !self.positive
  end
  
  def positivize!
    self.positive = true
    self.save!
  end
  
  def negativize!
    self.positive = false
    self.save!
  end
end
