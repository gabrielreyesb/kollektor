class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :series, optional: true
end
