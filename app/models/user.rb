class User < ActiveRecord::Base
    require 'digest'
    has_many :collections, class_name: "LinkCollection"
    has_and_belongs_to_many :viewable_collections, class_name: "LinkCollection"
    
    validates :email, presence: true
    
    def store_password!(password)
        self.salt = secure_hash("#{Time.now.utc.to_f}--#{password}")
        self.hashed_password = secure_hash("#{self.salt}--#{password}")
        self.save!
    end
    
    def password_matches?(password)
        secure_hash("#{self.salt}--#{password}") == self.hashed_password
    end
    
    private
    
    def secure_hash(string)
       Digest::SHA2.hexdigest(string) 
    end
end
