require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it "should have associations" do
    c = FactoryGirl.create :comment
    expect(c.respond_to?(:link)).to eq(true)
    expect(c.respond_to?(:user)).to eq(true)
  end
end
