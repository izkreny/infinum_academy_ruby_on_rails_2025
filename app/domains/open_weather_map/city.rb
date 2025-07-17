module OpenWeatherMap
  class City
    include Comparable
    attr_reader :id, :lat, :lon, :name

    def initialize(id:, lat:, lon:, name:, temp_k:)
      @id     = id
      @lat    = lat
      @lon    = lon
      @name   = name
      @temp_k = temp_k
    end

    # Temperature in Celsius
    def temp
      (@temp_k - 273.15).round(2)
    end

    def self.parse(city)
      City.new(
        id: city['id'],
        lat: city['coord']['lat'],
        lon: city['coord']['lon'],
        name: city['name'],
        temp_k: city['main']['temp']
      )
    end

    # Top nearest cities
    def near_by(count = 5) # rubocop:disable Metrics/MethodLength
      connection = Faraday.new(
        url: 'https://api.openweathermap.org/data/2.5/find',
        params: {
          lat: @lat,
          lon: @lon,
          cnt: count,
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

    def coldest_near_by(count = 5)
      near_by(count).min
    end

    def <=>(other)
      return name <=> other.name if temp == other.temp

      temp <=> other.temp
    end
  end
end
