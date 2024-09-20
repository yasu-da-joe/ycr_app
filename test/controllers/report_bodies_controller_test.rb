require "test_helper"

class ReportBodiesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get report_bodies_create_url
    assert_response :success
  end

  test "should get update" do
    get report_bodies_update_url
    assert_response :success
  end
end
