# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    username { Forgery(:name).company_name }
    email { Forgery(:internet).email_address }
    description { Forgery(:lorem_ipsum).words(20, random: true) }
  end
end
