class Route < ApplicationRecord
  TIME_FORMAT = "%H:%M"
  DIRECTIONS = %w(arrival departure)
  WEEKDAYS = Date::DAYNAMES.map.with_index { |day, idx| [day.downcase, idx] }.to_h.freeze

  delegate :city, to: :start_station, prefix: true
  delegate :city, to: :finish_station, prefix: true

  DIRECTIONS.each do |direction|
    validates "#{direction}_hours".to_sym, inclusion: { in: 0..23 }
    validates "#{direction}_minutes".to_sym, inclusion: { in: 0..59 }
  end

  validate :check_source_destination_equality
  validate :at_least_one_active_day

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
        %w(hours minutes).map { |unit| [direction, unit].join("_").to_sym }
                         .map { |cmd| send(cmd) }.join(":"),
                         TIME_FORMAT
        )
    end

    define_method "#{direction}_time_str" do
      [sprintf("%02d", send("#{direction}_hours")),
       sprintf("%02d", send("#{direction}_minutes"))].join(":")
    end
  end

  def weekdays(indexes = true)
    days_h = attributes.select{ |key, value| key.in?(WEEKDAYS.keys) && value == true }
    indexes ? days_h.keys.map {|key| WEEKDAYS[key] } : days_h.keys
  end

  private

  def check_source_destination_equality
    if start_station_id == finish_station_id
      errors.add(:base, "Source must not be equal to destination")
    end
  end

  def at_least_one_active_day
    unless sunday || monday || tuesday || thursday || friday || saturday || wednesday
      errors.add(:base, "At least one active day")
    end
  end
end
