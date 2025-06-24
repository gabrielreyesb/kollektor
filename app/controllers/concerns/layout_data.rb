module LayoutData
  extend ActiveSupport::Concern

  included do
    before_action :load_layout_data, if: :user_signed_in?
  end

  private

  def load_layout_data
    @genres = Genre.by_collection_type('Music').order(:name)
    @authors = current_user.authors.by_collection_type('Music').order(:name)
    @albums = current_user.albums.includes(:author, :genre).order(:name)
  end
end 