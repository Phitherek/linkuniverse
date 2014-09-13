# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    description "Test"
    url "http://rff-converter.phitherek.mooo.com"
    factory :filled_title_link do
      title "Other title"
    end
    factory :no_title_link do
      url "http://mirror.anl.gov/pub/ubuntu-iso/DVDs/ubuntu/14.10/alpha-1/source/utopic-src-1.iso"
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
