class Country < ApplicationRecord
  has_many :authors, dependent: :nullify
  
  validates :name, presence: true
  validates :code, presence: true, length: { is: 2 }, uniqueness: true
end 