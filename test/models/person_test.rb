# test/models/person_test.rb

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = Person.new(name: 'John Doe')
  end

  test 'should be valid' do
    assert @person.valid?
  end

  test 'name should be present' do
    @person.name = '   '
    assert_not @person.valid?
  end

  test 'should destroy associated detail' do
    @person.save
    @person.create_detail(title: 'Dr.', age: 30, phone: '123-456-7890', email: 'john@example.com')

    assert_difference 'Detail.count', -1 do
      @person.destroy
    end
  end
end
