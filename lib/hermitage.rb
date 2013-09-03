require 'hermitage/version'
require 'hermitage/defaults'
require 'hermitage/railtie' if defined? Rails
require 'hermitage/engine' if defined? Rails

module Hermitage

  mattr_accessor :configs

  # Hash of configs presets
  self.configs = { default: Hermitage::Defaults.to_hash() }
  
end