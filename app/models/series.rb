class Series < ApplicationRecord
  belongs_to :genre
  belongs_to :user
  
  has_one_attached :cover_image
  has_and_belongs_to_many :actors
  
  validates :name, presence: true
  validates :year, presence: true, numericality: { greater_than: 1900, less_than_or_equal_to: Date.current.year + 1 }
end 