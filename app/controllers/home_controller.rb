class HomeController < ApplicationController
  def index
    @albums = Album.includes(:author, :genre).order(year: :asc)
    
    if params[:genre_id].present?
      @albums = @albums.where(genre_id: params[:genre_id])
      # Filter available authors for this genre
      @filtered_authors = Author.joins(:albums)
                               .where(albums: { genre_id: params[:genre_id] })
                               .distinct
                               .order(:name)
      @filtered_albums = @albums.order(:name)
    elsif params[:author_id].present?
      @albums = @albums.where(author_id: params[:author_id])
      # Filter available genres for this author
      @filtered_genres = Genre.joins(:albums)
                             .where(albums: { author_id: params[:author_id] })
                             .distinct
                             .order(:name)
      @filtered_albums = @albums.order(:name)
    elsif params[:album_id].present?
      @albums = @albums.where(id: params[:album_id])
      album = Album.find(params[:album_id])
      @filtered_genres = Genre.where(id: album.genre_id)
      @filtered_authors = Author.where(id: album.author_id)
    else
      @filtered_genres = Genre.order(:name)
      @filtered_authors = Author.order(:name)
      @filtered_albums = Album.order(:name)
    end
    
    @albums = @albums.limit(24)
  end
end 