class ApplicationController < ActionController::Base
  before_action :set_filter_collections

  private

  def set_filter_collections
    @genres = Genre.order(:name)
    
    # Filter authors if genre is selected
    @authors = if params[:genre_id].present?
      DEBUG_LOGGER.info "Genre ID received: #{params[:genre_id]}"
      
      # Debug counts before the join
      DEBUG_LOGGER.info "Authors with this genre: #{Author.where(genre_id: params[:genre_id]).count}"
      DEBUG_LOGGER.info "Albums with this genre: #{Album.where(genre_id: params[:genre_id]).count}"
      
      query = Author.left_joins(:albums)
                   .where("authors.genre_id = :genre_id OR albums.genre_id = :genre_id", 
                         genre_id: params[:genre_id])
                   .distinct
                   .order(:name)
      
      DEBUG_LOGGER.info "SQL Query: #{query.to_sql}"
      result = query.to_a
      DEBUG_LOGGER.info "Results count: #{result.size}"
      DEBUG_LOGGER.info "Author IDs: #{result.map(&:id)}"
      
      result
    else
      DEBUG_LOGGER.info "No genre ID present, showing all authors"
      Author.order(:name)
    end
    
    @albums = Album.order(:name)
  end
end
