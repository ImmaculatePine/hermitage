# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hermitage/version'

Gem::Specification.new do |spec|
  spec.name          = 'hermitage'
  spec.version       = Hermitage::VERSION
  spec.authors       = ['Alexander Borovykh']
  spec.email         = ['immaculate.pine@gmail.com']
  spec.description   = %q{Ruby library for image galleries generation.}
  spec.summary       = %q{Ruby library for image galleries generation (thumbnails and original images viewer).}
  spec.homepage      = 'http://immaculatepine.github.io/hermitage/'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 3.2'
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'coffee-rails'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'therubyracer'
  spec.add_development_dependency 'poltergeist'
  spec.add_development_dependency 'genspec'
end
