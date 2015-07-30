# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    user
    price 10.5
    name "ProductString"
    trashed false
  end
end
