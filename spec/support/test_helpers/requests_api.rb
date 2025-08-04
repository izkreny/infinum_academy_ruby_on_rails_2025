module TestHelpers
  module RequestsApi
    DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S.%9N %z'

    def response_body(key = nil)
      return JSON.parse(response.body).deep_symbolize_keys if key.nil?

      JSON.parse(response.body).deep_symbolize_keys[key]
    end

    def random_hash
      random_string = ('a'..'z').to_a.shuffle.slice(1..5).join
      key           = 'random_key_'   << random_string
      value         = 'random_value_' << random_string
      { key => value }
    end

    def stringify_time(time)
      time.respond_to?(:strftime) ? time.strftime(DATETIME_FORMAT) : time
    end

    def stringify_time_values(hash)
      hash.deep_transform_values do |value|
        value.respond_to?(:strftime) ? value.strftime(DATETIME_FORMAT) : value
      end
    end
  end
end
