# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item_attr do
    product_id 1
    name "MyString"
    price 1.5
    trashed false
  end
end
