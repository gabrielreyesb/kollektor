class Genre < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  has_many :authors, dependent: :destroy
  has_many :albums, dependent: :destroy
end 