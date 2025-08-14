class Api::RatingsController < ApplicationController
  def create
    @album = current_user.albums.find(params[:album_id])
    @album.increment_likes
    @album.reload  # Make sure we have the fresh count
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "like-button-#{@album.id}",
            partial: "api/recommendations/like_button",
            locals: {
              album: @album,
              random_selection: params[:random_selection],
              genre_id: params[:genre_id],
              recommended_ids: params[:recommended_ids]
            }
          ),
          turbo_stream.update(
            "likes-count-#{@album.id}",
            @album.likes_count
          )
        ]
      end
      format.html { redirect_back(fallback_location: root_path) }
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("Album not found for rating: #{e.message}")
    render json: { error: "Album not found" }, status: :not_found
  rescue StandardError => e
    Rails.logger.error("Error in ratings: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    render json: { error: "An error occurred" }, status: :internal_server_error
  end
end 