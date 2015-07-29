# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product do
    user
    price 1.5
    name "MyString"
    trashed false
  end
end
