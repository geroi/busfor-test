# Не понадобилось
class FetchCity
  API_KEY = "AIzaSyBhkUm8b5ZIeRnlEx1vO5YAauIrwUl_H94".freeze

  @@cached_results = {}

  include Interactor

  def call
    @city_name = context.city_name
    return context.result = @@cached_results[@city_name] if @@cached_results[@city_name]

    search_results = search_for_city(@city_name)
    city_data = search_results.flat_map { |result| fetch_city_data(result) }
    city_names = city_data.map { |city_hash| city_hash["short_name"] }.uniq

    checked_names = city_names.flat_map { |name| city_check(name) }.first
    context.result = cache_result(@city_name, city_names)
  end

  def search_for_city(name)
    Geocoder.search(name, params: { countrycodes: "ru, ua" }, language: :en )
  end

  def fetch_city_data(geocoder_result)
    geocoder_result.data["address_components"]
                   .select { |component| component["types"].include?("locality") }
  end

  def cache_result(name, result)
    @@cached_results[name] ||= result
  end

  def city_check(name)
    url = URI.encode("https://maps.googleapis.com/maps/api/place/"\
                     "autocomplete/json?input=#{name}"\
                     "&key=#{API_KEY}&language=en")
    response = RestClient.get(url)
    parsed_response = JSON.parse(response.body)
    parsed_response.try { |res| res.dig("predictions", 0, "description") }
  end
end
