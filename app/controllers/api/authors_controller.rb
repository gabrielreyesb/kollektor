class Api::AuthorsController < ApplicationController
  def index
    @authors = if params[:genre_id].present?
                Author.where(genre_id: params[:genre_id]).order(:name)
              else
                Author.order(:name)
              end
    
    render json: @authors.select(:id, :name)
  end
end 