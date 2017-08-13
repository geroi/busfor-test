class ParseRouteLogs
  include Interactor

  def call
    seed_routes
  end

  private

  def grouped_routelogs
    RouteLog.all.group_by do |route_log|
      departure_hours, departure_minutes = route_log.departure_date_time.strftime('%H:%M').split(':')
      arrival_hours, arrival_minutes = route_log.arrival_date_time.strftime('%H:%M').split(':')
      {
        start_station_id: route_log.start_station.id,
        finish_station_id: route_log.finish_station.id,
        weekday: route_log.departure_date_time.wday,
        departure_hours: departure_hours.to_i,
        departure_minutes: departure_minutes.to_i,
        arrival_hours: arrival_hours.to_i,
        arrival_minutes: arrival_minutes.to_i,
        carrier_id: route_log.carrier_id
      }
    end
  end

  def seed_routes
    grouped_routelogs.keys.each { |route_hash| Route.create(**route_hash) }
  end
end
