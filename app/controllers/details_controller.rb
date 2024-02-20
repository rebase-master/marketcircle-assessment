# frozen_string_literal: true

# Handle Person details ops
class DetailsController < ApplicationController
  before_action :set_person, only: %i[create]
  before_action :set_detail, only: %i[update destroy]
  skip_before_action :verify_authenticity_token


  # POST /people/:person_id/details
  def create
    unless @person
      render json: { error: 'Person not found!' }, status: :not_found
      return
    end

    @detail = @person.build_detail(detail_params)
    if @detail.save
      render json: @detail, status: :created
    else
      render json: @detail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/:person_id/details/:id
  def update
    unless @detail
      render json: { error: 'Detail not found!' }, status: :not_found
      return
    end

    if @detail.update(detail_params)
      render json: @detail
    else
      render json: @detail.errors, status: :unprocessable_entity
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
