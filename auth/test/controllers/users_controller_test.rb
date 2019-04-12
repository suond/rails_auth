require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get Sessions" do
    get users_Sessions_url
    assert_response :success
  end

end
