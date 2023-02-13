# FHttpClient

Provides a basic skeleton for creating an HTTP client using the FService architecture.

## Installation

Add to your `.gemspec` client file `spec.add_runtime_dependency 'f_http_client'` and run `bundle install`.

## Configure

TODO: Write a congiguration guide here

## Usage

Could create a class:

```rb
module Person
  class Create < Base
    private

    def make_request(options)
      self.class.post('/persons', options)
    end
  end
end
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Fretadao/f_http_client.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
