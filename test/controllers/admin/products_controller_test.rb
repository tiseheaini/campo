require 'test_helper'

class Admin::ProductsControllerTest < ActionController::TestCase
  def setup
    login_as create(:admin)
  end

  test "should get index" do
    create :product
    get :index
    assert_response :success, @response.body
  end

  test "should get new page" do
    get :new
    assert_response :success, @response.body
  end

  test "should post product" do
    assert_difference "Product.count" do
      post :create, product: { name: 'name', price: '10.9' }
    end

    assert_no_difference "Product.count" do
      post :create, product: { name: '', price: '' }
    end

    assert_no_difference "Product.count" do
      post :create, product: { name: 'name', price: '' }
    end

    assert_no_difference "Product.count" do
      post :create, product: { name: '', price: '10.5' }
    end

    assert_no_difference "Product.count" do
      post :create, product: { name: 'name', price: 'price' }
    end
  end
end
