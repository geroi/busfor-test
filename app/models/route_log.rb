class RouteLog < ApplicationRecord
  belongs_to :start_station, class_name: 'Station'
  belongs_to :finish_station, class_name: 'Station'
  belongs_to :carrier
  belongs_to :currency
end
