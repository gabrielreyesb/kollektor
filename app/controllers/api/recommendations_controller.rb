class Api::RecommendationsController < ApplicationController
  def by_genre
    genre_id = params[:genre_id]
    @recommended_albums = Album.where(genre_id: genre_id)
                             .includes(:author, :genre)
                             .order("RANDOM()")
                             .limit(3)

    render partial: 'recommendations'
  end
end 