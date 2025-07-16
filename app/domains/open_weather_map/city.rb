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

    private

    def <=>(other)
      return name <=> other.name if temp == other.temp

      temp <=> other.temp
    end
  end
end
