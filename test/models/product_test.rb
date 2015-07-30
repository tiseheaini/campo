require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "should create product" do
    assert_not_nil create(:user)
  end

  test "should create not blank" do
    assert_no_difference "Product.count" do
      Product.create(name: '', price: '10.9')
    end

    assert_no_difference "Product.count" do
      Product.create(name: 'name', price: '')
    end
  end

  test "should create price is number" do
    assert_difference "Product.count" do
      Product.create(name: 'name', price: '10.5')
    end

    assert_no_difference "Product.count" do
      Product.create(name: 'name', price: '十元')
    end
  end
end
