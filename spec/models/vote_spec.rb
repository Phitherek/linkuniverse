require 'rails_helper'

RSpec.describe Vote, :type => :model do
  it "should have associations" do
    v = FactoryGirl.create :vote
    expect(v.respond_to?(:user)).to eq(true)
    expect(v.respond_to?(:voteable)).to eq(true)
  end
  
  it "should be positive by default" do
    v = FactoryGirl.create :vote
    expect(v.positive?).to eq(true)
  end
  
  it "should have working positive? and negative? methods" do
    v1 = FactoryGirl.create :vote
    v2 = FactoryGirl.create :negative_vote
    expect(v1.positive?).to eq(true)
    expect(v1.negative?).to eq(false)
    expect(v2.positive?).to eq(false)
    expect(v2.negative?).to eq(true)
  end
  
  it "should have working positivize! method" do
    v = FactoryGirl.create :negative_vote
    expect{v.positivize!}.not_to raise_error
    expect(v.positive?).to eq(true)
    expect(v.negative?).to eq(false)
  end
  
  it "should have working negativize! method" do
    v = FactoryGirl.create :vote
    expect{v.negativize!}.not_to raise_error
    expect(v.positive?).to eq(false)
    expect(v.negative?).to eq(true)
  end
end
