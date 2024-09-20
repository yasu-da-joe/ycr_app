require "test_helper"

class SetListOrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get set_list_orders_create_url
    assert_response :success
  end

  test "should get update" do
    get set_list_orders_update_url
    assert_response :success
  end

  test "should get destroy" do
    get set_list_orders_destroy_url
    assert_response :success
  end
end
