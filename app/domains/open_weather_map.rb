module OpenWeatherMap
  def self.city(city_name) # rubocop:disable Metrics/MethodLength
    city_id = OpenWeatherMap::Resolver.city_id(city_name)
    return nil if city_id.nil?

    connection = Faraday.new(
      url: 'https://api.openweathermap.org/data/2.5/weather',
      params: {
        id: city_id.to_s,
        appid: Rails.application.credentials.open_weather_map_api_key
      }
    ) { |builder| builder.response :json }

    begin
      response = connection.get
    rescue Exception # rubocop:disable Lint/RescueException
      Rails.logger.debug 'ERROR: Something went wrong while trying to connect to OpenWeather'
      nil
    else
      OpenWeatherMap::City.parse(response.body)
    end
  end

  def self.cities(cities)
    city_ids = cities.map { |city| OpenWeatherMap.city(city) }.compact
    return nil if city_ids.empty?

    connection = Faraday.new(
      url: 'https://api.openweathermap.org/data/2.5/group',
      params: {
        id: city_ids.join(','),
        appid: Rails.application.credentials.open_weather_map_api_key
      }
    ) { |builder| builder.response :json }

    begin
      response = connection.get
    rescue Exception # rubocop:disable Lint/RescueException
      Rails.logger.debug 'ERROR: Something went wrong while trying to connect to OpenWeather'
      nil
    else
      response.body.map { |city| OpenWeatherMap::City.parse(city) }
    end
  end
end
