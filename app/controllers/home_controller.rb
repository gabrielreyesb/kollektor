class HomeController < ApplicationController
  before_action :check_daily_mood

  def index
    @albums = Album.includes(:author, :genre)

    # Apply filters if present
    @albums = @albums.where(genre_id: params[:genre_id]) if params[:genre_id].present?
    @albums = @albums.where(author_id: params[:author_id]) if params[:author_id].present?
    @albums = @albums.where(id: params[:album_id]) if params[:album_id].present?

    # Limit to 24 albums only on the home page when no filters are applied
    @albums = @albums.limit(24) unless params[:genre_id].present? || params[:author_id].present? || params[:album_id].present?

    @albums = @albums.order(created_at: :desc)
  end

  private

  def check_daily_mood
    @show_mood_prompt = false
    last_visit = cookies[:last_mood_check]
    
    if last_visit.nil? || Time.parse(last_visit).to_date != Time.current.to_date
      @show_mood_prompt = true
      cookies[:last_mood_check] = Time.current
    end
  end
end 