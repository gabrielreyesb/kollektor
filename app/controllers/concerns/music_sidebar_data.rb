module MusicSidebarData
  extend ActiveSupport::Concern

  included do
    before_action :load_music_sidebar_data
  end

  private

  def load_music_sidebar_data
    @title = "Music Collection"
    @genres = Genre.by_collection_type('Music').order(:name)
    @authors = current_user.authors.order(:name)
    @albums_for_filter = current_user.albums.order(:name)
  end
end 