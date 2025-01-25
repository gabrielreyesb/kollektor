class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :authors, dependent: :destroy
  has_many :albums, dependent: :destroy

  scope :search, ->(query) {
    where("LOWER(genres.name) LIKE :query OR 
           LOWER(genres.description) LIKE :query", 
           query: "%#{query.downcase}%")
  }
end 