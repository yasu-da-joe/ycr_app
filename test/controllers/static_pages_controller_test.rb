require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about_us" do
    get static_pages_about_us_url
    assert_response :success
  end

  test "should get terms_of_service" do
    get static_pages_terms_of_service_url
    assert_response :success
  end

  test "should get privacy_policy" do
    get static_pages_privacy_policy_url
    assert_response :success
  end
end
