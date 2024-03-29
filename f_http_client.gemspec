# frozen_string_literal: true

require_relative 'lib/f_http_client/version'

Gem::Specification.new do |spec|
  spec.name = 'f_http_client'
  spec.version = FHTTPClient::VERSION
  spec.authors = ['Fretadao Tech Team']
  spec.email = ['tech@fretadao.com.br']

  spec.summary = 'Gem to provade a base for an HTTP client using FService architecture'
  spec.homepage = 'https://github.com/Fretadao/f_http_client'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/Fretadao/f_http_client/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'addressable'
  spec.add_runtime_dependency 'dry-configurable'
  spec.add_runtime_dependency 'dry-initializer'
  spec.add_runtime_dependency 'f_service', '>= 0.3.0'
  spec.add_runtime_dependency 'httparty'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'false'
end
