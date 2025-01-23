class HomeController < ApplicationController
  before_action :check_daily_mood

  def index
    @albums = Album.includes(:author, :genre)
                   .order('authors.name ASC, albums.year ASC')

    if params[:genre_id].present?
      @albums = @albums.where(genre_id: params[:genre_id])
                      .order('authors.name ASC, albums.year ASC')
      @authors = Author.joins(:albums)
                      .where(albums: { genre_id: params[:genre_id] })
                      .distinct
                      .order(:name)
    end

    if params[:author_id].present?
      @albums = @albums.where(author_id: params[:author_id])
    end

    if params[:album_id].present?
      @albums = @albums.where(id: params[:album_id])
    end
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