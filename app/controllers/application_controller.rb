class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_filter_collections

  private

  def set_filter_collections
    # Set empty collections if user not signed in
    unless user_signed_in?
      @genres = []
      @authors = []
      @albums = []
      return
    end
    
    @genres = current_user.genres.order(:name)
    
    # Filter authors if genre is selected
    @authors = if params[:genre_id].present?
      current_user.authors.left_joins(:albums)
            .where("authors.genre_id = :genre_id OR albums.genre_id = :genre_id", 
                  genre_id: params[:genre_id])
            .distinct
            .order(:name)
    else
      current_user.authors.order(:name)
    end
    
    @albums = current_user.albums.order(:name)
  end
end
