module Hermitage
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc 'Creates Hermitage configuration file at config/initializers and adds require statement to application.js file.'
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