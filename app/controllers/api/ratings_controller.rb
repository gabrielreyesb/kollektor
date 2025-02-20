class Api::RatingsController < ApplicationController
  def create
    @album = Album.find(params[:album_id])
    @album.increment_likes
    @album.reload  # Make sure we have the fresh count
    
    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: turbo_stream.replace(
          "like-button-#{@album.id}", 
          partial: "api/recommendations/like_button",
          locals: { 
            album: @album,
            random_selection: params[:random_selection],
            genre_id: params[:genre_id],
            recommended_ids: params[:recommended_ids]
          }
        )
      }
      format.html { redirect_back(fallback_location: root_path) }
    end
  end
end 