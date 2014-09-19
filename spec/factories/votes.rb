# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do
    positive true
    factory :negative_vote do
      positive false
    end
  end
end
