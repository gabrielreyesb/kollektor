class Api::MusicbrainzController < ApplicationController
  def search
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
    
    Rails.logger.info "MusicBrainz Response: #{response.inspect}"
    
    if response.success?
      render json: response.body
    else
      render json: { error: "MusicBrainz API Error", status: response.code, message: response.message }, status: response.code
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
  end
end 