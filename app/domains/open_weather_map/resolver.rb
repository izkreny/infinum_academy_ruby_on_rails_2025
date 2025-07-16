module OpenWeatherMap
  class Resolver
    def initialize; end

    def city_id(city_name)
      index = cities.find_index { |city| city['name'] == city_name }
      return nil if index.nil?

      cities[index]['id']
    end

    private

    def cities
      # TODO: Check and handle possible errors
      file_absolute_pathname = File.expand_path('city.list.json', __dir__)
      file_content = ''
      File.foreach(file_absolute_pathname) { |line| file_content << line } # File.read is too slow

      @cities ||= JSON.parse(file_content)
    end
  end
end
