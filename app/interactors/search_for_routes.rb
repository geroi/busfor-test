class SearchForRoutes
  include Interactor

  def call
    setup
    validate
    context.routes = find_routes
  rescue
    context.fail!
  end

  private

  def setup
    @start_city_id = context.start_city_id.to_i
    @finish_city_id = context.finish_city_id.to_i
  end

  def validate
    context.fail!(error: I18n.t("errors.search.unsufficient_data")) unless @start_city_id || @finish_city_id
    context.fail!(error: I18n.t("errors.search.same_city")) if @start_city_id == @finish_city_id
  end

  def find_routes
    Route.from_and_to_city(@start_city_id, @finish_city_id)
         .map { |route| RouteDecorator.new(route) }
  rescue
    context.fail!(error: I18n.t("errors.search.db_search"))
  end
end
