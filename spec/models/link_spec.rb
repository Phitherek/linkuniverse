require 'rails_helper'

RSpec.describe Link, :type => :model do
  it "should resolve title if empty title given" do
    l = FactoryGirl.build :link
    expect {l.save!}.not_to raise_error
    expect(l.title).to eq("RFF Converter")
  end
  
  it "should not resolve title if title given" do
    l = FactoryGirl.build :filled_title_link
    expect {l.save!}.not_to raise_error
    expect(l.title).to eq("Other title")
  end
  
  it "should paste link in title if title not resolved and not given" do
    l = FactoryGirl.build :no_title_link
    expect {l.save!}.not_to raise_error
    expect(l.title).to eq("http://mirror.anl.gov/pub/ubuntu-iso/DVDs/ubuntu/14.10/alpha-1/source/utopic-src-1.iso")
  end
  
  it "should raise error if link not correct and title not given" do
    l = FactoryGirl.build :broken_link
    expect {l.save!}.to raise_error
  end
  
  it "should raise error if link not correct and title given" do
    l = FactoryGirl.build :broken_filled_title_link
    expect {l.save!}.to raise_error
  end
  

  it "should have associations" do
    l = FactoryGirl.build :link
    expect(l.respond_to?(:collection)).to eq(true)
    expect(l.respond_to?(:comments)).to eq(true)
  end
end
