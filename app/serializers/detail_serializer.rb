class DetailSerializer < ActiveModel::Serializer
  attributes :id, :person_id, :title, :age, :phone, :email

end
