# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hermitage/version'

Gem::Specification.new do |spec|
  spec.name          = 'hermitage'
  spec.version       = Hermitage::VERSION
  spec.authors       = ['Alexander Borovykh']
  spec.email         = ['immaculate.pine@gmail.com']
  spec.description   = 'Ruby library for image galleries generation.'
  spec.summary       = 'Ruby library for image galleries generation (thumbnails and original images viewer).'
  spec.homepage      = 'http://immaculatepine.github.io/hermitage/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'coffee-rails'
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'rails', '>= 3.2', '< 5.0'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'capybara', '~> 2.15'
  spec.add_development_dependency 'genspec'
  spec.add_development_dependency 'lorax'
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'poltergeist', '~> 1.16'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rspec-rails', '~> 3.6'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'therubyracer'
end
