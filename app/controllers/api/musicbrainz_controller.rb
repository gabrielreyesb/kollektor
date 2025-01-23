class Api::MusicbrainzController < ApplicationController
  def search
    if params[:browse]
      browse_artist_albums
    else
      search_specific_album
    end
  end

  def release
    response = HTTParty.get(
      "https://musicbrainz.org/ws/2/release/#{params[:id]}",
      query: {
        inc: 'release-groups',
        fmt: 'json'
      },
      headers: {
        'User-Agent' => 'Kollektor/1.0.0 (your@email.com)',
        'Accept' => 'application/json'
      }
    )
    render json: response.body
  end

  def cover
    response = HTTParty.get("https://coverartarchive.org/release/#{params[:id]}/front")
    send_data response.body, type: response.headers['content-type'], disposition: 'inline'
  rescue StandardError => e
    render json: { error: "Cover not found" }, status: :not_found
  end

  private

  def browse_artist_albums
    artist = params[:artist]
    
    Rails.logger.debug "============ MUSICBRAINZ BROWSE DEBUG ============"
    Rails.logger.debug "Searching for artist: #{artist}"
    
    if artist.blank?
      Rails.logger.debug "Artist parameter is blank"
      render json: { error: "Artist parameter is required" }, status: :bad_request
      return
    end

    url = "https://musicbrainz.org/ws/2/release"
    query = {
      query: "artist:\"#{artist}\" AND status:official",
      fmt: "json",
      limit: 100,
      offset: 0
    }

    headers = {
      'User-Agent' => 'Kollektor/1.0.0 (your@email.com)',
      'Accept' => 'application/json'
    }

    begin
      response = HTTParty.get(
        url, 
        query: query,
        headers: headers,
        timeout: 10
      )
      
      if response.success?
        releases = response["releases"]
        render json: { releases: releases }
      else
        render json: { 
          error: "Error fetching data from MusicBrainz",
          details: response.message,
          code: response.code 
        }, status: :service_unavailable
      end
    rescue => e
      Rails.logger.error "Exception while fetching from MusicBrainz: #{e.message}"
      render json: { 
        error: "Error connecting to MusicBrainz",
        details: e.message 
      }, status: :service_unavailable
    end
    Rails.logger.debug "=============================================="
  end

  def search_specific_album
    response = HTTParty.get(
      "https://musicbrainz.org/ws/2/release/",
      query: {
        query: "#{params[:album]} AND artist:#{params[:artist]}",
        fmt: 'json'
      },
      headers: {
        'User-Agent' => 'Kollektor/1.0.0 (your@email.com)',
        'Accept' => 'application/json'
      }
    )
    
    if response.success?
      render json: { releases: response["releases"] }
    else
      render json: { error: "MusicBrainz API Error" }, status: :service_unavailable
    end
  end
end 