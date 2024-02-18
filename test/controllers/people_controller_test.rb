require "test_helper"

class PeopleControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get people_show_url
    assert_response :success
  end

  test "should get create" do
    get people_create_url
    assert_response :success
  end
end
