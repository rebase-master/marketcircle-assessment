# frozen_string_literal: true

class Person < ApplicationRecord

  validates :name, presence: true
  has_one :detail, dependent: :destroy

end
