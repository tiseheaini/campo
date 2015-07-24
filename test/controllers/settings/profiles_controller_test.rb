require 'test_helper'

class Settings::ProfilesControllerTest < ActionController::TestCase
  def setup
    login_as create(:user)
  end

  test "should get profile page" do
    get :show
    assert_response :success, @response.body
  end

  test "should update profile" do
    patch :update, user: { bio: 'update bio' }
    assert_equal 'update bio', current_user.reload.bio
  end
end
