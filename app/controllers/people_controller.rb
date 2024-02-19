# frozen_string_literal: true

# Handle people show and create actions
class PeopleController < ApplicationController
  before_action :set_person, only: [:show]
  skip_before_action :verify_authenticity_token

  def index
    @people = Person.all
  end

  def show
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'person-details',
          partial: 'people/show',
          locals: { details: @person&.detail }
        )
      end
      format.json { render json: { details: @person&.detail } }
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
    @person = nil
  end

  def person_params
    params.require(:person).permit(:name)
  end
end
