# frozen_string_literal: true

# Handle Person details ops
class DetailsController < ApplicationController
  before_action :set_person, only: %i[create new edit index update]
  before_action :set_detail, only: %i[update destroy]
  skip_before_action :verify_authenticity_token

  def index
    unless @person
      render json: { error: 'Person not found!' }, status: :not_found
      return
    end

    person_details = begin
                      ActiveModelSerializers::SerializableResource
                        .new(@person.detail, serializer: DetailSerializer)
                        .as_json
                     rescue StandardError
                      nil
                     end

    render turbo_stream: turbo_stream.replace(
      'person_details',
      partial: 'people/show',
      locals: { details: person_details }
    )
  end

  # POST /people/:person_id/details
  def create
    unless @person
      render json: { error: 'Person not found!' }, status: :not_found
      return
    end

    @detail = @person.build_detail(detail_params)
    if @detail.save
      person_details = ActiveModelSerializers::SerializableResource
                         .new(@detail, serializer: DetailSerializer)
                         .as_json
      render turbo_stream: turbo_stream.replace(
        'person_details',
        partial: 'people/show',
        locals: { details: person_details }
      )
    else
      render turbo_stream: turbo_stream.replace(
        'person_details',
        partial: 'details/create_form',
        locals: { person: @person, detail: @detail, errors: @detail.errors.full_messages }
      )
    end
  end

  def new
    @detail = Detail.new
  end

  def edit
    @detail = @person&.detail
  end

  # PATCH/PUT /people/:person_id/details/:id
  def update
    unless @detail
      render json: { error: 'Detail not found!' }, status: :not_found
      return
    end

    if @detail.update(detail_params)
      person_details = ActiveModelSerializers::SerializableResource
                       .new(@detail, serializer: DetailSerializer)
                       .as_json
      render turbo_stream: turbo_stream.replace(
        'person_details',
        partial: 'people/show',
        locals: { details: person_details }
      )
    else
      render turbo_stream: turbo_stream.replace(
        'person_details',
        partial: 'details/update_form',
        locals: { person: @person, errors: @detail.errors.full_messages }
      )
    end
  end

  # DELETE /people/:person_id/details/:id
  def destroy
    unless @detail
      render json: { error: 'Detail not found!' }, status: :not_found
      return
    end

    @detail.destroy
    head :no_content
  end

  private

  def set_person
    @person = Person.find(params[:person_id])
  rescue StandardError
    @person = nil
  end

  def set_detail
    @detail = Detail.find_by(id: params[:id], person_id: params[:person_id])
  rescue StandardError
    @detail = nil
  end

  def detail_params
    params.require(:detail).permit(:title, :age, :phone, :email)
  end
end
