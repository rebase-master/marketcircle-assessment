# frozen_string_literal: true

# Handle people show and create actions
class PeopleController < ApplicationController
  before_action :set_person, only: [:show]
  skip_before_action :verify_authenticity_token

  def show
    if @person
      render json: @person.to_json(include: :detail), status: :ok
    else
      render json: { error: "Person not found by id: #{params[:id]}" }, status: :unprocessable_entity
    end
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      render json: @person, status: :created
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  end

  private

  def set_person
    @person = Person.includes(:detail).find(params[:id])
  rescue StandardError
    @person = { message: 'Record not found!' }
  end

  def person_params
    params.require(:person).permit(:name)
  end
end
