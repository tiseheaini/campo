require 'test_helper'

class Settings::AccountsControllerTest < ActionController::TestCase
  def setup
    login_as create(:user, password: '123456')
  end

  test "should get settings account page" do
    get :show
    assert_response :success, @response.body
  end

  test "should update settings account" do
    patch :update, user: { email: 'user_change@example.com' }, current_password: '123456'
    assert_equal 'user_change@example.com', current_user.reload.email
  end
end
