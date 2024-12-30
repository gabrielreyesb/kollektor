class Api::AuthorsController < ApplicationController
  def index
    @authors = if params[:genre_id].present?
                Author.where(genre_id: params[:genre_id]).order(:name)
              else
                Author.order(:name)
              end
    
    Rails.logger.info "Genre ID: #{params[:genre_id]}"
    Rails.logger.info "Found authors: #{@authors.pluck(:name)}"
    
    render json: @authors.select(:id, :name)
  end
end 