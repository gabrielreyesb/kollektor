class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :check_daily_mood

  def index
    # If user is not logged in, show a welcome page
    unless user_signed_in?
      render 'welcome' and return
    end
    
    # Show collection selector dashboard
    @collection_types = CollectionType.all
    @first_series = current_user.series.where(seen: [false, nil]).order(:created_at).first
    render 'collections'
  end

  def albums
    # Legacy route - redirect to music collection
    redirect_to music_path
  end

  def get_lucky
    @recommended_albums = if Genre.exists?
      get_random_recommendations
    else
      []
    end
    @random_selection = true
    @title = "Random Suggestions"
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

  def get_random_recommendations
    recommended_albums = []
    
    # Get 4 random albums, favoring less liked ones
    4.times do
      # Get any random album we haven't selected yet, favoring less liked ones
      album = Album.includes(:author, :genre).with_attached_cover_image
                  .where.not(id: recommended_albums.map(&:id))
                  .weighted_by_likes
                  .first
      
      recommended_albums << album if album
    end

    recommended_albums
  end

  def get_title
    return "Welcome" unless user_signed_in?
    
    if params[:album_id].present?
      current_user.albums.find(params[:album_id]).name
    elsif params[:author_id].present?
      author_name = current_user.authors.find(params[:author_id]).name
      genre_name = Genre.find(params[:genre_id]).name if params[:genre_id].present?
      genre_name ? "#{author_name}'s Albums (#{genre_name})" : "#{author_name}'s Albums"
    elsif params[:genre_id].present?
      "#{Genre.find(params[:genre_id]).name} Albums"
    else
      "Recently Added"
    end
  end
end 