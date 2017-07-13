# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    description "Test"
    url "https://rff-converter.phitherek.me"
    association :user
    association :collection, factory: :link_collection
    factory :filled_title_link do
      title "Other title"
    end
    factory :no_title_link do
      url "https://notitle.phitherek.me"
    end
    factory :broken_link do
      url "broken"
    end
    factory :broken_filled_title_link do
      url "broken"
      title "Broken"
    end
  end
end
