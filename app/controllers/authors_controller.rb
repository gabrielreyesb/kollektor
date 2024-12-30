class AuthorsController < ApplicationController
  before_action :set_author, only: %i[ show edit update destroy ]
  before_action :load_dependencies, only: %i[ new edit create update ]

  def index
    @authors = Author.all.includes(:genre, :country)
  end

  def show
  end

  def new
    @author = Author.new
  end

  def edit
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to authors_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      redirect_to authors_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy!
    redirect_to authors_url
  end

  private
    def set_author
      @author = Author.find(params[:id])
    end

    def load_dependencies
      @genres = Genre.all
      @countries = Country.order(:name)
    end

    def author_params
      params.require(:author).permit(:name, :description, :genre_id, :country_id, :image)
    end
end 