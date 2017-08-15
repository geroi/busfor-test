class ParseRouteLogs
  include Interactor

  class RouteGroup < SimpleDelegator
    attr_reader :grouping_params
    attr_accessor :date_range

    def initialize(route_logs, grouping_params)
      raise unless route_logs.map(&:start_station_id).uniq.size == 1
      raise unless route_logs.map(&:finish_station_id).uniq.size == 1
      @grouping_params = grouping_params
      super(route_logs)
    end

    def weekdays
      weekdays_count.keys.select do |weekday|
        weekdays_count[weekday] == period_weekdays_count[weekday]
      end
    end

    def weekdays_for_db
      weekdays.map { |wd| [Date::DAYNAMES[wd].downcase, true] }
              .to_h.symbolize_keys
    end

    def route_params
      grouping_params.merge(weekdays_for_db)
    end

    def valid_route_logs
      @_valid_route_logs ||= route_logs.select do |route_log|
        route_log.departure_date_time.wday.in?(weekdays)
      end
    end

    private

    def weekdays_count
      group_by { |route_log| route_log.departure_date_time.wday }
        .map { |wday, logs| [wday, logs.count] }
        .to_h
        .symbolize_keys
    end

    def period_weekdays_count
      date_range.group_by { |date| date.wday }
                .map {|wday, days| [wday, days.count] }
                .to_h
                .symbolize_keys
    end

    def date_range
      @date_range || Range.new(assoc.minimum(:departure_date_time).beginning_of_day.to_datetime,
                               assoc.maximum(:departure_date_time).end_of_day.to_datetime)
    end

    def assoc
      @_assoc ||= RouteLog.where(id: map(&:id))
    end
  end

  def call
    routes
  end

  private

  def hours_minutes(route_log, destination = :departure)
    route_log.send("#{destination}_date_time")
             .strftime('%H:%M')
             .split(':')
             .map(&:to_i)
  end

  def routelogs_groups
    RouteLog.all.group_by do |route_log|
      departure_hours, departure_minutes = hours_minutes(route_log, :departure)
      arrival_hours, arrival_minutes = hours_minutes(route_log, :arrival)
      {
        start_station_id: route_log.start_station.id,
        finish_station_id: route_log.finish_station.id,
        departure_hours: departure_hours,
        departure_minutes: departure_minutes,
        arrival_hours: arrival_hours,
        arrival_minutes: arrival_minutes,
        carrier_id: route_log.carrier_id
      }
    end
  end

  def route_groups
    routelogs_groups.map do |grouping_params, route_logs|
     RouteGroup.new(route_logs, grouping_params).tap do |route_group|
      route_group.date_range =
        Range.new(RouteLog.minimum(:departure_date_time).beginning_of_day.to_datetime,
                  RouteLog.maximum(:departure_date_time).end_of_day.to_datetime)
    end
   end
  end

  def routes
    route_groups.each do |route_group|
      visualize_routes(route_group)
      Route.create(**route_group.route_params).tap do |route|
        puts route.errors.blank? ? "OK".black.on_green.rjust(20, " ") :
                                   "ERR #{route.errors.full_messages}".white.on_red
        puts("\n\n")
      end
    end
    puts("Total accepted #{Route.count}")
  end

  def visualize_routes(route_logs)
    dates = route_logs.send(:date_range).to_a
    puts("ПВСЧПСВ")
    dates.each_slice(7).each do |week|
      week_line = week.map.with_index do |date, idx|
        text = route_logs.find do |rl|
          rl.try(:departure_date_time).try(:to_date) == date.try(:to_date)
        end ? "X" : "_"
        [0,1,2,3,4,5,6].rotate(1)[idx].in?(route_logs.weekdays) ? text.green : text
      end.join("")
      puts(week_line)
    end
  end
end
