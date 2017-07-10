require 'rails_helper'

RSpec.describe User, :type => :model do
  it { should validate_presence_of(:email) }
  
  it { should validate_uniqueness_of(:email) }
  
  it { should validate_uniqueness_of(:username) }
  
  it "should store encrypted password and enable user to login with it" do
    @user = FactoryGirl.create :user
    expect(@user.password_digest).not_to be(nil)
    expect(@user.authenticate('testtest')).not_to be_falsey
  end
  
  it "should have associations" do
    u = FactoryGirl.create :user
    expect(u.respond_to?(:collections)).to eq(true)
    expect(u.respond_to?(:viewable_collections)).to eq(true)
  end
end
