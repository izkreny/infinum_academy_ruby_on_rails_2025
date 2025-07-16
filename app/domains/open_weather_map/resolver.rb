module OpenWeatherMap
  class Resolver
    def initialize; end

    def self.city_id(city_name)
      # TODO: Check and handle possible errors
      file_absolute_pathname = File.expand_path('city.list.json', __dir__)
      file_content = ''
      File.foreach(file_absolute_pathname) { |line| file_content << line } # File.read is too slow
      cities = JSON.parse(file_content)
      index  = cities.find_index { |city| city['name'] == city_name }
      return nil if index.nil?

      cities[index]['id']
    end
  end
end
