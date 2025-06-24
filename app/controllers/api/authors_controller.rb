class Api::AuthorsController < ApplicationController
  def index
    @authors = if params[:genre_id].present?
                Author.by_collection_type('Music').where(genre_id: params[:genre_id]).order(:name)
              else
                Author.by_collection_type('Music').order(:name)
              end
    
    render json: @authors.select(:id, :name)
  end
end 