# frozen_string_literal: true

module Post
  class Find < FHTTPClient::Base
    base_uri 'https://jsonplaceholder.typicode.com'

    private

    def make_request
      self.class.get(formatted_path, headers: headers)
    end

    def path_template
      '/posts/%<id>s'
    end

    def headers
      @headers.merge(content_type: 'application/json')
    end
  end
end

# Post::Find.(path_params: { id: 1 })
#   .and_then { |response| response.parsed_response }
#
# => {
#     userId: 1,
#     id: 1,
#     title: "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
#     body: "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
#    }
