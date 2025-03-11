class Genre < ApplicationRecord
  belongs_to :user, optional: true
  
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
  has_many :authors, dependent: :destroy
  has_many :albums, dependent: :destroy

  scope :search, ->(query) {
    where("LOWER(genres.name) LIKE :query OR 
           LOWER(genres.description) LIKE :query", 
           query: "%#{query.downcase}%")
  }
end 