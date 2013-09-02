require 'simple_gallery/version'
require 'simple_gallery/defaults'
require 'simple_gallery/railtie' if defined? Rails

module SimpleGallery

  mattr_accessor :setups

  # Hash of options for rendering
  self.setups = { default: SimpleGallery::Defaults.to_hash() }


  module Rails
    class Engine < ::Rails::Engine
    end
  end
  
end