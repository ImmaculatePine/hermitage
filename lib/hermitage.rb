require 'hermitage/version'
require 'hermitage/defaults'
require 'hermitage/railtie' if defined? Rails

module Hermitage

  mattr_accessor :configs

  # Hash of configs presets
  self.configs = { default: Hermitage::Defaults.to_hash() }


  module Rails
    class Engine < ::Rails::Engine
    end
  end
  
end