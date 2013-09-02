module Hermitage
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc 'Creates configuration file for hermitage at config/initializers'
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer
        template 'hermitage.rb', 'config/initializers/hermitage.rb'
      end
    end
  end
end