# test/controllers/people_controller_test.rb

require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get people_url
    assert_response :success
  end

  # Add more tests for other actions as needed
end
