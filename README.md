# FHTTPClient

Provides a basic skeleton for creating an HTTP client using the FService architecture.

## Installation

Add to your `.gemspec` client file `spec.add_runtime_dependency 'f_http_client'` and run `bundle install`.

## Configure

The gem allow the following configuration

- base_uri: a URI to be used for all services for your client;
- log_strategy: s symbol representing which logger the gem will use;
  - null (default): means that the client will not log anything;
  - rails: means that Rails logger will be used;
  - any other value the gem will use a default logger which loggs at STDOUT.
- cache
  - strategy: Defines which cache strategy will be used;
    - null (default): the client does not log anything;
    - rails: the Rails.cache will be used to perform caching;
  - expires_in: Deines in seconds how much time the cache will be kept (default 0).

```rb
module BlogClient
  class Configuration < FHTTPClient::Configuration
    setting :paginate do
      setting :enabled, default: true
      setting :per_page, :20
    end
  end
end

BlogClient::Configuration.configure do |config|
  config.base_uri = 'https://jsonplaceholder.typicode.com'
  confg.log_strategy = :rails

  config.cache.strategy = :rails
  config.cache.expires_in = 25.minutes
  config.paginate.per_page = 50
end


class BlogClient::Base < FHTTPClient::Base
  def self.config
    BlogClient::Configuration.config
  end

  cache_expires_in 10.minutes
end
```

## Usage

Could create a class:

```rb
# frozen_string_literal: true

module BlogClient
  module Post
    class Find < BlogClient::Base
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
end

# BlogClient::Post::Find.(path_params: { id: 1 })
#   .and_then { |response| response.parsed_response }
#
# => {
#     userId: 1,
#     id: 1,
#     title: "How to use a FHTTPCLient Gem",
#     body: "A great text here."
#    }
```

Result examples:

```rb
Person::Create.(name: 'Joe Vicenzo', birthdate: '2000-01-01')
  .and_then { |user| return redirect_to users_path(user.id) }
  .on_failure(:unprocessable_entity) { |errors| return render_action :new, locals: { errors: errors } }
  .on_failure(:client_error) { |errors| render_action :new, warning: errors }
  .on_failure(:server_error) { |error| render_action :new, warning: ['Try again latter.'] }
  .on_failure(:server_error) { |error| render_action :new, warning: ['Server is busy. Try again latter.'] }
  .on_failure { |_error, type| render_action :new, warning: ["Unexpected error. Contact admin and talk about #{type} error."] }
```

This gem uses the gem [HTTParty](https://github.com/jnunemaker/httparty) as base to perform requests.
Then we can use any [example](https://github.com/jnunemaker/httparty/tree/master/examples) to implements the method make_request, for GET, POST, PUT, etc.
The class *FHTTPClient::Base* provides the following options to help building the request:
- *headers*: can be used to provide custom headers;
- *query*: can be used to provide querystring params;
- *body*: can be used to provide a body when request requires this;
- *options*: can be used provide any other option for HTTParty;
- *path_params*, can be used to fills params which is in the request path.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fretadao/f_http_client.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
