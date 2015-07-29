# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :indent do
    user_id 1
    product_id 1
    count 1
    address_id 1
    paymented false
    trashed false
  end
end
