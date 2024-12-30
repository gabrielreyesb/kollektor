class Album < ApplicationRecord
  belongs_to :genre
  belongs_to :author
  has_one_attached :cover_image

  validates :name, presence: true
  validates :year, presence: true, 
            numericality: { only_integer: true, 
                          greater_than: 1900, 
                          less_than_or_equal_to: Time.current.year }
  validates :genre, presence: true
  validates :author, presence: true
  validate :acceptable_cover_image, if: :cover_image_attached?

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