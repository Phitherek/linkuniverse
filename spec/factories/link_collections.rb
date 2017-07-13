# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link_collection do
    name "Test"
    association :user
    factory :public_link_collection do
      pub true
    end
  end
end
