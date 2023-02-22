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


## Usage

Could create a class:

```rb
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
```

And usage:

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
