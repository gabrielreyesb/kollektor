class ApplicationController < ActionController::Base
  before_action :set_sidebar_data

  private

  def set_sidebar_data
    @genres = Genre.order(:name)
    @authors = Author.order(:name)
    @albums = Album.order(:name)
  end
end
