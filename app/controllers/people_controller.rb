# frozen_string_literal: true

# Handle people show and create actions
class PeopleController < ApplicationController
  before_action :set_person, only: [:show]
  skip_before_action :verify_authenticity_token

  def index
    @people = Person.all
  end

  def show
    unless @person
      render json: { error: 'Person not found!' }, status: :not_found
      return
    end

    person_details = ActiveModelSerializers::SerializableResource
                     .new(@person.detail, serializer: DetailSerializer)
                     .as_json

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'person-details',
          partial: 'people/show',
          locals: { details: person_details }
        )
      end
      format.json { render json: person_details }
    end
  end

  def create
    @person = Person.new(person_params)

    if @person.save
      render json: @person, status: :created
    else
      render json: @person.errors, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: e.message }
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
