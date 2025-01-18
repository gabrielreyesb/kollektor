class HomeController < ApplicationController
  def index
    @albums = Album.includes(:author, :genre)
                   .order('authors.name ASC, albums.year ASC')
                   .page(params[:page])
                   .per(12)

    Rails.logger.debug "=== PAGINATION DEBUG ==="
    Rails.logger.debug "Total albums: #{Album.count}"
    Rails.logger.debug "Current page: #{params[:page]}"
    Rails.logger.debug "Albums in page: #{@albums.size}"
    Rails.logger.debug "======================="

    respond_to do |format|
      format.html
    end
  end
end 