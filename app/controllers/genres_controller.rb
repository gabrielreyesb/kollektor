class GenresController < ApplicationController
  before_action :set_genre, only: %i[ show edit update destroy ]

  def index
    @genres = current_user.genres
    @genres = @genres.search(params[:search]) if params[:search].present?
    @genres = @genres.order(:name)
  end

  def show
    authorize_genre_access
  end

  def new
    @genre = Genre.new
  end

  def edit
    authorize_genre_access
  end

  def create
    @genre = current_user.genres.new(genre_params)

    if @genre.save
      redirect_to genres_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize_genre_access
    if @genre.update(genre_params)
      redirect_to genres_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize_genre_access
    @genre.destroy!
    redirect_to genres_url
  end

  private
    def set_genre
      @genre = Genre.find(params[:id])
    end

    def authorize_genre_access
      unless @genre.user == current_user
        flash[:alert] = "You are not authorized to access this genre"
        redirect_to genres_path
      end
    end

    def genre_params
      params.require(:genre).permit(:name, :description)
    end
end 