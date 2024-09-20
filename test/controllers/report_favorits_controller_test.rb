require "test_helper"

class ReportFavoritsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get report_favorits_create_url
    assert_response :success
  end

  test "should get destroy" do
    get report_favorits_destroy_url
    assert_response :success
  end
end
