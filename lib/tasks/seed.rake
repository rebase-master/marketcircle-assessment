require 'json'

namespace :db do

  desc 'Seed database with initial values from the data/people.json file'
  task seed: :environment do

    file_path = 'data/people.json'
    json_data = JSON.parse(File.read(file_path))
    people_attributes = json_data.map { |person_data| { name: person_data['name'] } }
    people = Person.create(people_attributes)

    details_attributes = []

    people.each_with_index do |person, index|
      details_data = json_data[index]['info']
      details_attributes << {
        person_id: person.id,
        title: details_data['title'],
        age: details_data['age'],
        phone: details_data['phone'],
        email: details_data['email']
      }
    end

    Detail.create(details_attributes)

  end
end
