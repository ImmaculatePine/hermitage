require 'simple_gallery/version'
require 'simple_gallery/railtie' if defined? Rails

module SimpleGallery
  module Rails
    class Engine < ::Rails::Engine
    end
  end
end