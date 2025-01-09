class HomeController < ApplicationController
  def index
    @albums = Album.includes(:author, :genre)
                   .joins(:author)
                   .order('authors.name ASC, albums.year ASC')
                   .page(params[:page])
                   .per(24)
    
    if params[:genre_id].present?
      @albums = @albums.where(genre_id: params[:genre_id])
      # Filter available authors for this genre
      @filtered_authors = Author.joins(:albums)
                               .where(albums: { genre_id: params[:genre_id] })
                               .distinct
                               .order(:name)
      @filtered_albums = @albums.joins(:author).order('authors.name ASC, albums.year ASC')
    elsif params[:author_id].present?
      @albums = @albums.where(author_id: params[:author_id])
      # Filter available genres for this author
      @filtered_genres = Genre.joins(:albums)
                             .where(albums: { author_id: params[:author_id] })
                             .distinct
                             .order(:name)
      @filtered_albums = @albums.order(year: :asc)
    elsif params[:album_id].present?
      @albums = @albums.where(id: params[:album_id])
      album = Album.find(params[:album_id])
      @filtered_genres = Genre.where(id: album.genre_id)
      @filtered_authors = Author.where(id: album.author_id)
    else
      @filtered_genres = Genre.order(:name)
      @filtered_authors = Author.order(:name)
      @filtered_albums = Album.joins(:author).order('authors.name ASC, albums.year ASC')
    end
    
    # Build header text based on filters
    @header_text = build_header_text

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.append(
          "entries",
          partial: "albums/album",
          collection: @albums
        )
      end
    end
  end

  private

  def build_header_text
    filters = []
    
    if params[:genre_id].present?
      genre = Genre.find(params[:genre_id])
      filters << genre.name
    end
    
    if params[:author_id].present?
      author = Author.find(params[:author_id])
      filters << author.name
    end
    
    if filters.empty?
      "All Albums"
    else
      "Albums by #{filters.join(' & ')}"
    end
  end
end 