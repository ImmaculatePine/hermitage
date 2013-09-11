require 'hermitage/version'
require 'hermitage/defaults'
require 'hermitage/configurator'
require 'hermitage/railtie' if defined? Rails
require 'hermitage/engine' if defined? Rails

module Hermitage

  mattr_accessor :configs

  # Hash of configs presets
  self.configs = { default: Hermitage::Defaults.to_hash() }
  
  def self.configure(config_name, &block)
    configurator = Configurator.new(config_name, &block)
  end

end