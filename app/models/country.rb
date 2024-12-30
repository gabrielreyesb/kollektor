class Country < ApplicationRecord
  has_many :authors
  
  validates :name, presence: true
  validates :code, presence: true, length: { is: 2 }, uniqueness: { case_sensitive: false }
end 