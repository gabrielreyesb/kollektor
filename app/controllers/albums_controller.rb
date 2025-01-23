class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]
  before_action :load_dependencies, only: %i[ new edit create update ]

  def index
    @albums = Album.all.includes(:genre, :author)
  end

  def show
  end

  def new
    @album = Album.new
    @genres = Genre.order(:name)
    @authors = Author.order(:name)
  end

  def edit
    @genres = Genre.order(:name)
    @authors = Author.order(:name)
  end

  def create
    @album = Album.new(album_params)

    if @album.save
      redirect_to albums_path
    else
      load_dependencies
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @album.update(album_params)
      redirect_to albums_path
    else
      load_dependencies
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @album.destroy!
    redirect_to albums_url
  end

  def search_info
    query = params[:query]
    # Add your search logic here
    # For example, using an external API or database search
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "search_results",
          partial: "search_results",
          locals: { results: @results }
        )
      end
    end
  end

  private
    def set_album
      @album = Album.find(params[:id])
    end

    def load_dependencies
      @genres = Genre.all
      @authors = Author.all
    end

    def album_params
      params.require(:album).permit(:name, :description, :year,
                                  :genre_id, :author_id, :cover_image)
    end
end 