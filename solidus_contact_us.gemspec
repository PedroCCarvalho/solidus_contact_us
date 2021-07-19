# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'solidus_contact_us/version'

Gem::Specification.new do |s|
  s.name = 'solidus_contact_us'
  s.version = SolidusContactUs::VERSION
  s.summary = 'Reworked the contact_us gem to add a basic contact us form to Spree.'
  s.description = s.summary

  s.required_ruby_version = '>= 2.2'

  s.author = 'Jonathan Tapia'
  s.homepage = 'http://github.com/jtapia/solidus_contact_us'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'solidus_core', ['>= 2.2', '< 4']
  s.add_dependency 'solidus_auth_devise', ['>= 2.2', '< 3']
  s.add_dependency 'solidus_support'
  s.add_dependency 'deface', '~> 1.0'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop', '>= 0.49.0'
  s.add_development_dependency 'rubocop-rspec', '1.4.0'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
