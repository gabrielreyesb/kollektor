class CollectionType < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  
  has_many :genres, dependent: :restrict_with_error
  has_many :authors, dependent: :restrict_with_error
  
  scope :search, ->(query) {
    where("LOWER(collection_types.name) LIKE :query OR 
           LOWER(collection_types.description) LIKE :query", 
           query: "%#{query.downcase}%")
  }
end 