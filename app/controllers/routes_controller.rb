class RoutesController < ApplicationController
  def search
    @cities = City.all
  end
end
