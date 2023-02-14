# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in f_http_client.gemspec
gemspec

group :development do
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'rubocop-performance'
  gem 'f_service', github: 'Fretadao/f_service', branch: 'bv-add-multiple-failures'
end

group :test do
  gem 'rspec', '~> 3.0'
  gem 'simplecov'
  gem 'webmock'
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rake', '~> 13.0'
end
