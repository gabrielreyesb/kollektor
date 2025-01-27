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

    # Set title variables for the view
    @title = get_title
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

  def get_title
    if params[:album_id].present?
      Album.find(params[:album_id]).name
    elsif params[:author_id].present?
      author_name = Author.find(params[:author_id]).name
      genre_name = Genre.find(params[:genre_id]).name if params[:genre_id].present?
      genre_name ? "#{author_name}'s Albums (#{genre_name})" : "#{author_name}'s Albums"
    elsif params[:genre_id].present?
      "#{Genre.find(params[:genre_id]).name} Albums"
    else
      "Recently Added"
    end
  end
end 