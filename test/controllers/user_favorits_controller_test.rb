require "test_helper"

class UserFavoritsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_favorits_create_url
    assert_response :success
  end

  test "should get destroy" do
    get user_favorits_destroy_url
    assert_response :success
  end
end
