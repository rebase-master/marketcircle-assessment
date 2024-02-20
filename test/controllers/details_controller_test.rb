# test/controllers/details_controller_test.rb
require 'test_helper'

class DetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @person = Person.create(name: 'John Doe')
    @detail = Detail.create(title: 'Mr', age: 32, phone: '555-232-1232', email: 'johnd@example.com')
  end

  test 'should create detail' do
    assert_difference('Detail.count', 1) do
      post person_details_url(@person), params: { detail: { title: 'Dr.', age: 30, phone: '123-456-7890', email: 'john@example.com' } }, as: :json
    end

    assert_response 201
    assert JSON.parse(response.body).key?('id'), 'Response should contain the detail ID'
  end

  test 'should not create detail with invalid params' do
    assert_no_difference('Detail.count') do
      post person_details_url(@person), params: { detail: { title: nil, age: 30, phone: '123-456-7890', email: nil } }, as: :json
    end
    assert_response 422
    assert JSON.parse(response.body).map{ |k, v| [k, v].join(' ') }, "email can't be blank"
  end

  test 'should update detail' do
    @person.detail = @detail
    patch person_detail_url(@person, @detail), params: { detail: { title: 'Prof.' } }, as: :json
    assert_response 200
    assert_equal 'Prof.', @detail.reload.title
  end

  test 'should not update detail with invalid params' do
    @person.detail = @detail
    patch person_detail_url(@person, @detail), params: { detail: { email: nil } }, as: :json
    assert_response 422
    assert JSON.parse(response.body).map{ |k, v| [k, v].join(' ') }, "email can't be blank"
  end

  test 'should destroy detail' do
    @person.detail = @detail
    assert_difference('Detail.count', -1) do
      delete person_detail_url(@person, @detail), as: :json
    end

    assert_response 204
  end

  test 'should not destroy non-existent detail' do
    assert_no_difference('Detail.count') do
      delete person_detail_url(@person, id: 999), as: :json
    end

    assert_response 404
  end

end
