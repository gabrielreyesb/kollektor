class Genre < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :collection_type
  
  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
  has_many :authors, dependent: :destroy
  has_many :albums, dependent: :destroy
  has_many :series, dependent: :destroy

  scope :search, ->(query) {
    where("LOWER(genres.name) LIKE :query OR 
           LOWER(genres.description) LIKE :query", 
           query: "%#{query.downcase}%")
  }
  
  scope :by_collection_type, ->(collection_type_name) {
    joins(:collection_type).where(collection_types: { name: collection_type_name })
  }
  
  # Fallback scope when collection_type doesn't exist
  scope :with_collection_type, -> {
    joins(:collection_type)
  }
end 