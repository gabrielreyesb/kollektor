class Actor < ApplicationRecord
  has_one_attached :photo
  has_and_belongs_to_many :series

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
