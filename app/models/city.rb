class City < ApplicationRecord
  has_many :stations, dependent: :destroy
  has_many :route_logs, through: :stations, dependent: :destroy
end
