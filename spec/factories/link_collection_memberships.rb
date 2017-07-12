# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link_collection_membership do
    association :user
    association :link_collection
    active false
    permission 'view'
  end
end
