class CountriesController < ApplicationController
  before_action :set_country, only: %i[ show edit update destroy ]

  def index
    @countries = Country.all.order(:name)
  end

  def new
    @country = Country.new
  end

  def edit
  end

  def create
    @country = Country.new(country_params)

    if @country.save
      redirect_to countries_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @country.update(country_params)
      redirect_to countries_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @country.destroy!
    redirect_to countries_url
  end

  private
    def set_country
      @country = Country.find(params[:id])
    end

    def country_params
      params.require(:country).permit(:name, :code)
    end
end 