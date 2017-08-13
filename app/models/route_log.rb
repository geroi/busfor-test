class RouteLog < ApplicationRecord
  validates_presence_of :start_station,
                        :finish_station,
                        :carrier,
                        :currency
  belongs_to :start_station, class_name: 'Station'
  belongs_to :finish_station, class_name: 'Station'
  belongs_to :carrier
  belongs_to :currency
end
