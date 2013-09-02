require 'hermitage/view_helpers'

module Hermitage
  class Railtie < Rails::Railtie
    initializer 'hermitage.view_helpers' do |app|
      ActionView::Base.send :include, ViewHelpers
    end
  end 
end