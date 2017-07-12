require 'rails_helper'

RSpec.describe LinkCollectionMembership, :type => :model do
  it { is_expected.to belong_to :link_collection }
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_presence_of :link_collection_id }
end
