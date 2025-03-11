class AuthorsController < ApplicationController
  before_action :set_author, only: %i[ show edit update destroy ]
  before_action :load_dependencies, only: %i[ new edit create update ]

  def index
    @authors = current_user.authors.includes(:genre, :country)
    @authors = @authors.search(params[:search]) if params[:search].present?
    @authors = @authors.order(:name)
  end

  def show
    authorize_author_access
  end

  def new
    @author = Author.new
  end

  def edit
    authorize_author_access
  end

  def create
    @author = current_user.authors.new(author_params)

    if @author.save
      redirect_to authors_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize_author_access
    if @author.update(author_params)
      redirect_to authors_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_author_access
    @author.destroy!
    redirect_to authors_url
  end

  private
    def set_author
      @author = Author.find(params[:id])
    end

    def authorize_author_access
      unless @author.user == current_user
        flash[:alert] = "You are not authorized to access this author"
        redirect_to authors_path
      end
    end

    def load_dependencies
      @genres = Genre.order(:name)
      @countries = Country.order(:name)
    end

    def author_params
      params.require(:author).permit(:name, :description, :genre_id, :country_id, :image)
    end
end 