class Api::RecommendationsController < ApplicationController
  def by_genre
    if params[:id] == 'random'
      # Get a mix of albums from different genres and authors
      @recommended_albums = []
      
      # Get 3 different genres
      genre_ids = Genre.joins(:albums).distinct.pluck(:id).sample(3)
      
      # For each genre, get a random album from a different author
      genre_ids.each do |genre_id|
        album = Album.includes(:author, :genre)
                    .where(genre_id: genre_id)
                    .where.not(author_id: @recommended_albums.map(&:author_id))
                    .order("RANDOM()")
                    .first
        @recommended_albums << album if album
      end

      # If we got less than 3 albums, fill with random albums
      if @recommended_albums.size < 3
        existing_ids = @recommended_albums.map(&:id)
        remaining = Album.includes(:author, :genre)
                        .where.not(id: existing_ids)
                        .order("RANDOM()")
                        .limit(3 - @recommended_albums.size)
        @recommended_albums += remaining
      end

      @random_selection = true
    else
      @genre = Genre.find(params[:id])
      @recommended_albums = Album.where(genre_id: @genre.id)
                               .includes(:author)
                               .order("RANDOM()")
                               .limit(3)
    end

    render partial: 'recommendations'
  end
end 