class Author < ApplicationRecord
  belongs_to :genre
  belongs_to :country
  has_one_attached :image
  has_many :albums, dependent: :destroy
  
  validates :name, presence: true
  validates :genre_id, presence: true
  validates :country_id, presence: true
  validate :acceptable_image, if: :image_attached?
  
  private
    def image_attached?
      image.attached?
    end
    
    def acceptable_image
      return unless image.attached?
      
      unless image.byte_size <= 5.megabyte
        errors.add(:image, "must be less than 5MB")
      end
    end
end 