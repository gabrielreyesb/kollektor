class ApplicationController < ActionController::Base
  before_action :set_filter_collections

  private

  def set_filter_collections
    @genres = Genre.order(:name)
    
    # Filter authors if genre is selected
    @authors = if params[:genre_id].present?
      Rails.logger.debug "Genre ID received: #{params[:genre_id]}"
      
      # Debug counts before the join
      Rails.logger.debug "Authors with this genre: #{Author.where(genre_id: params[:genre_id]).count}"
      Rails.logger.debug "Albums with this genre: #{Album.where(genre_id: params[:genre_id]).count}"
      
      query = Author.left_joins(:albums)
                   .where("authors.genre_id = :genre_id OR albums.genre_id = :genre_id", 
                         genre_id: params[:genre_id])
                   .distinct
                   .order(:name)
      
      Rails.logger.debug "SQL Query: #{query.to_sql}"
      result = query.to_a
      Rails.logger.debug "Results count: #{result.size}"
      Rails.logger.debug "Author IDs: #{result.map(&:id)}"
      
      result
    else
      Rails.logger.debug "No genre ID present, showing all authors"
      Author.order(:name)
    end
    
    @albums = Album.order(:name)
  end
end
