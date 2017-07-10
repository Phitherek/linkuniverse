require 'rails_helper'

RSpec.describe LinkCollection, :type => :model do
  
  it { should validate_presence_of(:name) }
  
  it "should be non-public by default" do
    c = FactoryGirl.create :link_collection
    expect(c.pub).to eq(false)
  end
  
  describe "pub? method" do
    it "should return false if collection non-public" do
      c = FactoryGirl.create :link_collection
      expect(c.pub?).to eq(false)
    end
    
    it "should return true if collection public" do
      c = FactoryGirl.create :public_link_collection
      expect(c.pub?).to eq(true)
    end
  end
  
  describe "pub! method" do
    it "should make non-public collection public" do
      c = FactoryGirl.create :link_collection
      c.pub!
      expect(c.pub?).to eq(true)
    end
  end
  
  describe "unpub! method" do
    it "should make public collection non-public" do
      c = FactoryGirl.create :public_link_collection
      c.unpub!
      expect(c.pub?).to eq(false)
    end
  end
  
  it "should have associations" do
    c = FactoryGirl.create :link_collection
    expect(c.respond_to?(:parent)).to eq(true)
    expect(c.respond_to?(:children)).to eq(true)
    expect(c.respond_to?(:links)).to eq(true)
    expect(c.respond_to?(:user)).to eq(true)
    expect(c.respond_to?(:viewers)).to eq(true)
  end
end
