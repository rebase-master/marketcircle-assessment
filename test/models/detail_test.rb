# test/models/detail_test.rb

require 'test_helper'

class DetailTest < ActiveSupport::TestCase
  def setup
    @person = Person.new(name: 'John Doe')
    @detail = Detail.new(title: 'Dr.', age: 30, phone: '123-456-7890', email: 'john@example.com', person: @person)
  end

  test 'should be valid' do
    assert @detail.valid?
  end

  test 'email should be present' do
    @detail.email = '   '
    assert_not @detail.valid?
  end

  test 'should belong to a person' do
    @detail.person = nil
    assert_not @detail.valid?
  end
end
