require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should validate_presence_of(:email) }
  
  it { should validate_uniqueness_of(:email) }
  
  it { should validate_uniqueness_of(:username) }
  
  it "should store encrypted password and enable user to login with it" do
    @user = FactoryGirl.create :user
    @user.store_password!("test")
    expect(@user.salt).not_to be_nil
    expect(@user.hashed_password).not_to be_nil
    expect(@user.password_matches?("test")).to eq(true)
  end
  
  it "should generate different salts and hashes" do    
    @user = FactoryGirl.create :user
    @user2 = FactoryGirl.create :user
    @user.store_password!("test")
    @user2.store_password!("test")
    expect(@user.salt).not_to eq(@user2.salt)
    expect(@user.hashed_password).not_to eq(@user2.hashed_password)
  end
  
  it "should have associations" do
    u = FactoryGirl.create :user
    expect(u.respond_to?(:collections)).to eq(true)
    expect(u.respond_to?(:viewable_collections)).to eq(true)
  end
end
