class RoutesController < ApplicationController
  def search
    @cities = City.all
  end

  def search_results
    result = SearchForRoutes.call(start_city_id: params.dig(:search,:start_city),
                                  finish_city_id: params.dig(:search,:finish_city))
    if result.success?
      @route_views = result.route_views
    else
      redirect_to :index, flash: { error: result.error }
    end
  end
end
