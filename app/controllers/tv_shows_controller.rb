class TvShowsController < ApplicationController
  before_action :load_sidebar_data

  def index
    redirect_to series_index_path, status: :moved_permanently
  end

  private

  def load_sidebar_data
    # TODO: Load genres and authors filtered by the 'Series' collection type
    @genres = Genre.none
    @authors = Author.none
    @tv_shows_for_filter = current_user.tv_shows.order(:name)
  end
end
