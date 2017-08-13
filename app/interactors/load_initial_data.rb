class LoadInitialData
  include Interactor
  DATE_FORMAT = "%H:%M %d.%m.%Y".freeze
  FIELD_NAMES = [:start_city_name,
                 :station_begin_name,
                 :start_date,
                 :start_time,
                 :end_city_name,
                 :station_end_name,
                 :end_date,
                 :end_time,
                 :carrier_name,
                 :total_cost,
                 :currency].freeze
  Route = Struct.new(*FIELD_NAMES)

  def call
    @routes = []
    data_files = context.files
    routes_array = load_routes(data_files)
    seed_routes(routes_array)
  end

  private

  def load_routes(filenames)
    filenames.reduce(@routes) do |routes, filename|
      loaded_routes = YAML.load(File.open(filename))
      routes.push(loaded_routes.map do |route_hash|
        Route.new(*route_hash.values)
      end)
    end.flatten
  end

  def seed_routes(routes)
    routes.each do |route|
      start_city = City.find_or_create_by(name: route.start_city_name)
      finish_city = City.find_or_create_by(name: route.end_city_name)

      start_station = Station.find_or_create_by(name: route.station_begin_name, city: start_city)
      finish_station = Station.find_or_create_by(name: route.station_end_name, city: finish_city)

      carrier = Carrier.find_or_create_by(name: route.carrier_name)
      currency = Currency.find_or_create_by(name: route.currency)
      price = route.total_cost.to_f

      departure_date_time = DateTime.strptime("#{route.start_time} #{route.start_date}", DATE_FORMAT)
      arrival_date_date = DateTime.strptime("#{route.end_time} #{route.end_date}", DATE_FORMAT)

      ::RouteLog.create(start_station: start_station,
                        finish_station: finish_station,
                        departure_date_time: departure_date_time,
                        arrival_date_time: arrival_date_date,
                        carrier: carrier,
                        currency: currency,
                        total_cost: price)
    end
  end
end
