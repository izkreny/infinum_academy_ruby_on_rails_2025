module TestHelpers
  module RequestsApi
    def response_body
      JSON.parse(response.body)
    end

    def random_word
      'random_word_' << ('a'..'z').to_a.shuffle.slice(1..5).join
    end
  end
end
