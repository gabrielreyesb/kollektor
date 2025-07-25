class MusicController < ApplicationController
  include MusicSidebarData

  def index
    load_albums
    
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("albums-grid", partial: "albums")
      end
    end
  end

  def load_more
    load_albums
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("albums-grid", partial: "albums")
      end
    end
  end

  private

  def load_albums
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

    # Apply pagination
    page = params[:page]&.to_i || 1
    per_page = 20
    
    @albums = @albums.offset((page - 1) * per_page).limit(per_page)
    @has_more = base_query.count > (page * per_page)

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