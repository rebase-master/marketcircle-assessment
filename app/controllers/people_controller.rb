# frozen_string_literal: true

# Handle people show and create actions
class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :destroy]
  skip_before_action :verify_authenticity_token

  def index
    @people = Person.all
  end

  def show
    unless @person
      render json: { error: 'Person not found!' }, status: :not_found
      return
    end
    render turbo_stream: turbo_stream.replace(
      "person_#{@person.id}",
      partial: 'people/person',
      locals: { person: @person }
    )
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

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to person_url, notice: 'Person was successfully updated' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  rescue StandardError => e
    render json: { error: e.message }
  end

  # DELETE /people/:id
  def destroy
    unless @person
      render json: { error: 'Detail not found!' }, status: :not_found
      return
    end

    @person.destroy
    head :no_content
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
