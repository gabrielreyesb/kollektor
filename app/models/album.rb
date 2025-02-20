class Album < ApplicationRecord
  belongs_to :genre
  belongs_to :author
  has_one_attached :cover_image

  validates :name, presence: true, 
                  uniqueness: { 
                    scope: :author_id,
                    case_sensitive: false,
                    message: "already exists for this author" 
                  }
  validates :year, presence: true, 
            numericality: { only_integer: true, 
                          greater_than: 1900, 
                          less_than_or_equal_to: Time.current.year }
  validates :genre, presence: true
  validates :author, presence: true
  validate :acceptable_cover_image, if: :cover_image_attached?

  scope :search, ->(query) {
    joins(:author, :genre)
      .where("LOWER(albums.name) LIKE :query OR 
              LOWER(authors.name) LIKE :query OR 
              LOWER(genres.name) LIKE :query", 
              query: "%#{query.downcase}%")
  }

  def increment_likes
    increment!(:likes_count)
  end

  def youtube_music_url
    "https://music.youtube.com/search?q=#{URI.encode_www_form_component("#{name} #{author.name} album")}"
  end

  def wikipedia_url
    base_url = "https://en.wikipedia.org/api/rest_v1/page/summary/"
    # Create a Wikipedia-friendly title format
    title = "#{name} (#{author.name} album)"
    formatted_title = title.gsub(' ', '_')
    
    response = HTTParty.get(
      "#{base_url}#{URI.encode_www_form_component(formatted_title)}",
      headers: {
        'User-Agent' => 'KollektorApp/1.0',
        'Accept' => 'application/json'
      }
    )

    if response.success?
      "https://en.wikipedia.org/wiki/#{formatted_title}"
    else
      # Fallback to search if direct lookup fails
      "https://en.wikipedia.org/wiki/Special:Search?" + {
        search: "#{author.name} #{name} album",
        ns0: 1,
        fulltext: 1,
        profile: "advanced"
      }.to_query
    end
  rescue => e
    Rails.logger.error("Wikipedia API error: #{e.message}")
    # Fallback URL in case of any error
    "https://en.wikipedia.org/wiki/Special:Search?search=#{URI.encode_www_form_component("#{author.name} #{name} album")}"
  end

  private
    def cover_image_attached?
      cover_image.attached?
    end

    def acceptable_cover_image
      return unless cover_image.attached?
      
      if cover_image.byte_size > 5.megabytes
        errors.add(:cover_image, "must be less than 5MB")
      end
      
      acceptable_types = ["image/jpeg", "image/png", "image/jpg"]
      unless acceptable_types.include?(cover_image.content_type)
        errors.add(:cover_image, "must be a JPEG or PNG")
      end
    end
end 