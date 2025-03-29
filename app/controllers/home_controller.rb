class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :check_daily_mood

  def index
    # If user is not logged in, show a welcome page
    unless user_signed_in?
      render 'welcome' and return
    end
    
    # Start with a base query that includes the necessary associations
    base_query = current_user.albums.includes(:author, :genre)

    # Apply filters if present
    if params[:genre_id].present?
      Rails.logger.debug "Filtering by genre_id: #{params[:genre_id]}"
      base_query = base_query.where(genre_id: params[:genre_id]) 
    end
    
    if params[:author_id].present?
      Rails.logger.debug "Filtering by author_id: #{params[:author_id]}"
      base_query = base_query.where(author_id: params[:author_id]) 
    end
    
    if params[:album_id].present?
      Rails.logger.debug "Filtering by album_id: #{params[:album_id]}"
      base_query = base_query.where(id: params[:album_id]) 
    end

    # Apply ordering based on filters
    @albums = if params[:author_id].present?
                # When filtering by author, order by year
                base_query.order('albums.year ASC')
              else
                # Default ordering by creation date (most recent first)
                base_query.order('albums.created_at DESC')
              end

    # Limit results if no filters are applied
    if !params[:genre_id].present? && !params[:author_id].present? && !params[:album_id].present?
      Rails.logger.debug "No filters applied, limiting to 24 albums"
      @albums = @albums.limit(24)
    end

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