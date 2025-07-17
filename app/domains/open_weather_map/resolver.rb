module OpenWeatherMap
  class Resolver
    def initialize; end

    def self.city_id(city_name) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      # TODO: Check and handle possible errors
      file_absolute_pathname = File.expand_path('city.list.json', __dir__)
      file_content = ''
      File.foreach(file_absolute_pathname) { |line| file_content << line } # File.read is too slow
      cities = JSON.parse(file_content)
      index  = cities.find_index { |city| city['name'] == city_name }
      if index.nil?
        fuzzy = FuzzyMatch.new(cities, read: 'name')
        city  = fuzzy.find(city_name)
        return nil if city.nil?

        Rails.logger.debug "City '#{city_name}' not found. Did you mean: #{city['name']}?"
        return nil
      end

      cities[index]['id']
    end
  end
end
