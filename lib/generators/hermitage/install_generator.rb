module Hermitage
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc 'Creates configuration file for hermitage at config/initializers'
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        template 'hermitage.rb', 'config/initializers/hermitage.rb'
      end

      def insert_require_into_application_js
        inject_into_file 'app/assets/javascripts/application.js', "\n//= require hermitage", after: %r{^//= require +['"]?jquery['"]?$}
      end
      
    end
  end
end