class SearchForRoutes
  include Interactor

  module SourceDestination
    attr_accessor :source
    attr_accessor :destination
  end

  def call
    setup
    validate
    search
    context.route_views = wrap_route_views
  end

  private

  def setup
    @start_city_id = context.start_city_id.try(:to_i)
    @finish_city_id = context.finish_city_id.try(:to_i)
  end

  def validate
    context.fail!(error: I18n.t("errors.search.unsufficient_data")) unless @start_city_id || @finish_city_id
    context.fail!(error: I18n.t("errors.search.same_city")) if @start_city_id == @finish_city_id
  end

  def search
    routes = Route.from_and_to_city(@start_city_id, @finish_city_id)
    @route_views = GroupRoutes.call(routes: routes).result
  rescue
    context.fail!(error: I18n.t("errors.search.db_search"))
  end

  def wrap_route_views
    @route_views.tap do |r_v|
      r_v.extend(SourceDestination)
      r_v.source = City.find(@start_city_id)
      r_v.destination = City.find(@finish_city_id)
    end
  end
end
