class SeriesCollectionController < ApplicationController
  before_action :authenticate_user!

  def index
    @series = current_user.series.where(seen: [false, nil]).includes(:genre).with_attached_cover_image.order(created_at: :desc).limit(24)
    @title = "Series & Movies Collection"
  end
end
