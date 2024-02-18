# frozen_string_literal: true

class Detail < ApplicationRecord
  belongs_to :person

  validates :email, presence: true

end
