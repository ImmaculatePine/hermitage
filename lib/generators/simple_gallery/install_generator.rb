module SimpleGallery
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc 'Creates configuration file for simple_gallery at config/initializers'
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        template 'simple_gallery.rb', 'config/initializers/simple_gallery.rb'
      end
    end
  end
end