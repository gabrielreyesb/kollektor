class Api::RecommendationsController < ApplicationController
  def by_genre
    if params[:id] == 'random'
      @recommended_albums = if Genre.exists?
        get_random_recommendations
      else
        []
      end
      @random_selection = true
    else
      @genre = Genre.find(params[:id])
      @recommended_albums = Album.where(genre_id: @genre.id)
                               .includes(:author)
                               .order("RANDOM()")
                               .limit(4)
    end

    render partial: 'recommendations'
  end

  private

  def get_random_recommendations
    recommended_albums = []
    used_genre_ids = []
    
    # Try to get 4 albums with different genres
    4.times do
      # Exclude already used genres
      album = Album.includes(:author, :genre)
                  .where.not(genre_id: used_genre_ids)
                  .where.not(id: recommended_albums.map(&:id))
                  .order("RANDOM()")
                  .first

      if album
        recommended_albums << album
        used_genre_ids << album.genre_id
      else
        # If we can't find an album with different genre,
        # just get any random album we haven't selected yet
        remaining = Album.includes(:author, :genre)
                        .where.not(id: recommended_albums.map(&:id))
                        .order("RANDOM()")
                        .first
        recommended_albums << remaining if remaining
      end
    end

    recommended_albums
  end
end 