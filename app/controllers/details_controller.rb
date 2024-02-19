# frozen_string_literal: true

# Handle Person details ops
class DetailsController < ApplicationController
  before_action :set_person, only: [:index, :create]
  before_action :set_detail, only: [:show, :update, :destroy]

  # GET /people/:person_id/details
  def index
    @details = @person.details
    render json: @details
  end

  # GET /people/:person_id/details/:id
  def show
    render json: @detail
  end

  # POST /people/:person_id/details
  def create
    @detail = @person.details.build(detail_params)

    if @detail.save
      render json: @detail, status: :created
    else
      render json: @detail.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/:person_id/details/:id
  def update
    if @detail.update(detail_params)
      render json: @detail
    else
      render json: @detail.errors, status: :unprocessable_entity
    end
  end

  # DELETE /people/:person_id/details/:id
  def destroy
    @detail.destroy
    head :no_content
  end

  private

  def set_person
    @person = Person.find(params[:person_id])
  end

  def set_detail
    @detail = Detail.find(params[:id])
  end

  def detail_params
    params.require(:detail).permit(:title, :age, :phone, :email)
  end
end
