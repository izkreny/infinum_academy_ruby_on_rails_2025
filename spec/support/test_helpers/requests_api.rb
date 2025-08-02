module TestHelpers
  module RequestsApi
    DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S.%9N %z'

    def response_body(key = nil)
      return JSON.parse(response.body) if key.nil?

      JSON.parse(response.body)[key.to_s]
    end

    def random_hash
      key   = 'random_key_'   << ('a'..'z').to_a.shuffle.slice(1..5).join
      value = 'random_value_' << ('a'..'z').to_a.shuffle.slice(1..5).join
      { key => value }
    end

    def stringify_time(datetime)
      datetime.respond_to?(:strftime) ? datetime.strftime(DATETIME_FORMAT) : datetime.to_s
    end

    def stringify_time_values(params)
      params
        .compact
        .transform_values do |value|
          value.respond_to?(:strftime) ? value.strftime(DATETIME_FORMAT) : value
        end
    end
  end
end
