class MusicController < ApplicationController
  include MusicSidebarData

  def index
    # Start with a base query that includes the necessary associations
    base_query = current_user.albums.includes(:author, :genre).with_attached_cover_image

    # Apply filters if present
    if params[:genre_id].present?
      base_query = base_query.where(genre_id: params[:genre_id]) 
    end
    
    if params[:author_id].present?
      base_query = base_query.where(author_id: params[:author_id]) 
    end
    
    if params[:album_id].present?
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
      @albums = @albums.limit(24)
    end

    # Set title variables for the view
    @title = get_title
  end

  private

  def get_title
    if params[:album_id].present?
      current_user.albums.find(params[:album_id]).name
    elsif params[:author_id].present?
      author_name = current_user.authors.find(params[:author_id]).name
      genre_name = Genre.find(params[:genre_id]).name if params[:genre_id].present?
      genre_name ? "#{author_name}'s Albums (#{genre_name})" : "#{author_name}'s Albums"
    elsif params[:genre_id].present?
      "#{Genre.find(params[:genre_id]).name} Albums"
    else
      "Music Collection"
    end
  end
end 