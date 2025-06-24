class TvShow < ApplicationRecord
  belongs_to :genre
  belongs_to :author
  belongs_to :user

  has_one_attached :cover_image

  validates :name, presence: true
end
