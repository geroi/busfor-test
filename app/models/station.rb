class Station < ApplicationRecord
  belongs_to :city
  has_many :route_logs, foreign_key: :start_station_id, dependent: :delete_all
end
