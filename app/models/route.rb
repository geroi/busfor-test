class Route < ApplicationRecord
  TIME_FORMAT = "%H:%M"
  DIRECTIONS = %w(arrival departure)

  validates_uniqueness_of :weekday,
                          scope: [:start_station_id,
                                  :finish_station_id,
                                  :departure_hours,
                                  :departure_minutes,
                                  :arrival_hours,
                                  :arrival_minutes,
                                  :carrier_id]
  DIRECTIONS.each do |direction|
    validates "#{direction}_hours".to_sym, inclusion: { in: 0..23 }
    validates "#{direction}_minutes".to_sym, inclusion: { in: 0..59 }
  end

  validates :weekday, inclusion: { in: 0..6 }
  validate :check_source_destination_equality

  belongs_to :start_station, class_name: "Station"
  belongs_to :finish_station, class_name: "Station"
  belongs_to :carrier, dependent: :destroy

  scope :from_city, ->(city_id) { joins(start_station: :city).where("stations.city_id == ?", city_id) }
  scope :to_city, ->(city_id) { joins(finish_station: :city).where("stations.city_id == ?", city_id) }

  def self.from_and_to_city(source_id, destination_id)
    src_ids = from_city(source_id).pluck(:id)
    dest_ids = to_city(destination_id).pluck(:id)
    where(id: src_ids & dest_ids)
  end

  # Generating reader methods for arrival/direction time
  DIRECTIONS.each do |direction|
    define_method "#{direction}_time" do
      Time.strptime(
        %(hours minutes).map { |unit| [direction, unit].join("_").to_sym }
                        .map { |cmd| send(cmd) }.join(":"),
                        TIME_FORMAT
        )
    end

    define_method "#{direction}_time_str" do
      [sprintf("%02d", send("#{direction}_hours")),
       sprintf("%02d", send("#{direction}_minutes"))].join(":")
    end
  end

  private

  def check_source_destination_equality
    if start_station_id == finish_station_id
      errors.add("Source must not be equal to destination")
    end
  end
end
