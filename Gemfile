# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in f_http_client.gemspec
gemspec

group :development do
  gem 'benchmark' # Required by rubocop on Ruby 4+
  gem 'racc' # Required by parser on Ruby 4+
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'rubocop-vicenzo'
end

group :test do
  gem 'csv' # Required by httparty on Ruby 4+ (moved from stdlib)
  gem 'ostruct' # Required by simplecov on Ruby 4+ (moved from stdlib)
  gem 'rspec', '~> 3.0'
  gem 'simplecov'
  gem 'webmock'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rake', '~> 13.0'
end
