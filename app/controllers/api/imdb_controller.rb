class Api::ImdbController < ApplicationController
  def search
    query = params[:query]
    Rails.logger.debug "[IMDB] search params: #{params.inspect}"
    
    if query.blank?
      Rails.logger.debug "[IMDB] search: query param is blank"
      return render json: { error: "Query parameter is required" }, status: :bad_request
    end

    omdb_url = "http://www.omdbapi.com/"
    omdb_query = {
      s: query,
      apikey: ENV['OMDB_API_KEY']
    }
    Rails.logger.debug "[IMDB] search: OMDB API request: #{omdb_url} with #{omdb_query.inspect}"

    response = HTTParty.get(omdb_url, query: omdb_query, timeout: 10)
    Rails.logger.debug "[IMDB] search: OMDB API response code: #{response.code}"
    Rails.logger.debug "[IMDB] search: OMDB API response body: #{response.body}"

    if response.success?
      data = JSON.parse(response.body)
      Rails.logger.debug "[IMDB] search: parsed data: #{data.inspect}"
      
      if data["Response"] == "True"
        render json: { 
          success: true, 
          results: data["Search"] || [],
          total_results: data["totalResults"]
        }
      else
        Rails.logger.debug "[IMDB] search: OMDB API error: #{data['Error']}"
        render json: { 
          success: false, 
          error: data["Error"] || "No results found" 
        }
      end
    else
      Rails.logger.debug "[IMDB] search: HTTP request failed"
      render json: { error: "Failed to fetch data from OMDB API" }, status: :service_unavailable
    end
  rescue => e
    Rails.logger.error "[IMDB] search: Exception: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
  end

  def details
    imdb_id = params[:id]
    Rails.logger.debug "[IMDB] details params: #{params.inspect}"
    
    if imdb_id.blank?
      Rails.logger.debug "[IMDB] details: imdb_id param is blank"
      return render json: { error: "IMDB ID is required" }, status: :bad_request
    end

    omdb_url = "http://www.omdbapi.com/"
    omdb_query = {
      i: imdb_id,
      apikey: ENV['OMDB_API_KEY']
    }
    Rails.logger.debug "[IMDB] details: OMDB API request: #{omdb_url} with #{omdb_query.inspect}"

    response = HTTParty.get(omdb_url, query: omdb_query, timeout: 10)
    Rails.logger.debug "[IMDB] details: OMDB API response code: #{response.code}"
    Rails.logger.debug "[IMDB] details: OMDB API response body: #{response.body}"

    if response.success?
      data = JSON.parse(response.body)
      Rails.logger.debug "[IMDB] details: parsed data: #{data.inspect}"
      
      if data["Response"] == "True"
        render json: { 
          success: true, 
          series: data
        }
      else
        Rails.logger.debug "[IMDB] details: OMDB API error: #{data['Error']}"
        render json: { 
          success: false, 
          error: data["Error"] || "Series or movie not found" 
        }
      end
    else
      Rails.logger.debug "[IMDB] details: HTTP request failed"
      render json: { error: "Failed to fetch series or movie details from OMDB API" }, status: :service_unavailable
    end
  rescue => e
    Rails.logger.error "[IMDB] details: Exception: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
  end

  def poster
    imdb_id = params[:id]
    Rails.logger.debug "[IMDB] poster params: #{params.inspect}"
    
    if imdb_id.blank?
      Rails.logger.debug "[IMDB] poster: imdb_id param is blank"
      return render json: { error: "IMDB ID is required" }, status: :bad_request
    end

    omdb_url = "http://www.omdbapi.com/"
    omdb_query = {
      i: imdb_id,
      apikey: ENV['OMDB_API_KEY']
    }
    Rails.logger.debug "[IMDB] poster: OMDB API request: #{omdb_url} with #{omdb_query.inspect}"

    response = HTTParty.get(omdb_url, query: omdb_query, timeout: 10)
    Rails.logger.debug "[IMDB] poster: OMDB API response code: #{response.code}"
    Rails.logger.debug "[IMDB] poster: OMDB API response body: #{response.body}"

    if response.success?
      data = JSON.parse(response.body)
      Rails.logger.debug "[IMDB] poster: parsed data: #{data.inspect}"
      
      if data["Response"] == "True" && data["Poster"] && data["Poster"] != "N/A"
        # Redirect to the poster URL
        redirect_to data["Poster"]
      else
        Rails.logger.debug "[IMDB] poster: Poster not available"
        render json: { error: "Poster not available" }, status: :not_found
      end
    else
      Rails.logger.debug "[IMDB] poster: HTTP request failed"
      render json: { error: "Failed to fetch poster from OMDB API" }, status: :service_unavailable
    end
  rescue => e
    Rails.logger.error "[IMDB] poster: Exception: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
  end

  def poster_proxy
    poster_url = params[:url]
    Rails.logger.debug "[IMDB] poster_proxy params: #{params.inspect}"
    
    if poster_url.blank?
      Rails.logger.debug "[IMDB] poster_proxy: url param is blank"
      return render json: { error: "Poster URL is required" }, status: :bad_request
    end

    # Validate that it's an IMDB poster URL
    unless poster_url.include?('imdb.com') || poster_url.include?('media-amazon.com')
      Rails.logger.debug "[IMDB] poster_proxy: Invalid poster URL"
      return render json: { error: "Invalid poster URL" }, status: :bad_request
    end

    begin
      # Fetch the image
      response = HTTParty.get(poster_url, timeout: 10)
      
      if response.success? && response.headers['content-type']&.start_with?('image/')
        # Set appropriate headers
        response.headers.each do |key, value|
          response.headers[key] = value unless key.downcase == 'set-cookie'
        end
        # Stream the image data
        send_data response.body, 
                  type: response.content_type, 
                  disposition: 'inline',
                  filename: 'poster.jpg'
      else
        Rails.logger.debug "[IMDB] poster_proxy: Failed to fetch poster: #{response.code}"
        # Return a default SVG image
        send_data default_poster_svg, type: 'image/svg+xml', disposition: 'inline', filename: 'default_poster.svg'
      end
    rescue => e
      Rails.logger.error "[IMDB] poster_proxy: Exception: #{e.class} - #{e.message}"
      # Return a default SVG image
      send_data default_poster_svg, type: 'image/svg+xml', disposition: 'inline', filename: 'default_poster.svg'
    end
  end

  private

  def default_poster_svg
    <<~SVG
      <svg width="60" height="90" viewBox="0 0 60 90" fill="none" xmlns="http://www.w3.org/2000/svg">
        <rect width="60" height="90" fill="#67748B"/>
        <path d="M20 25H40V65H20V25Z" fill="#495057"/>
        <path d="M15 30L25 40L15 50V30Z" fill="#495057"/>
        <path d="M45 30L55 40L45 50V30Z" fill="#495057"/>
      </svg>
    SVG
  end
end 