class GroupRoutes
  include Interactor

  class Weekday < SimpleDelegator
    def to_word
      I18n.t('date.day_names')[self]
    end
  end

  RouteView = Struct.new(:start_station, :finish_station,
                         :departure_time, :arrival_time,
                         :carrier_name, :weekdays) do
    def weekdays_str
      return I18n.t("date.everyday") if everyday?
      weekdays.sort.map(&:to_word).map(&:capitalize).join(' ')
    end

    def everyday?
      ((0..6).to_a - weekdays.map(&:to_i)).empty?
    end
  end

  def call
    @routes = context.routes
    context.result = route_views(group_routes)
  end

  private

  def route_views(groups)
    groups.map do |(start, finish, depart, arriv, carrier), routes|
      RouteView.new(start, finish, depart, arriv, carrier, weekdays(routes))
    end
  end

  def group_routes
    @routes.group_by do |route|
      [route.start_station,
       route.finish_station,
       route.departure_time_str,
       route.arrival_time_str,
       route.carrier.name]
    end
  end

  def weekdays(routes)
    routes.map { |route| Weekday.new(route.weekday) }
  end
end
