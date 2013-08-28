require 'simple_gallery/view_helpers'

module SimpleGallery
  class Railtie < Rails::Railtie
    initializer 'simple_gallery.view_helpers' do |app|
      ActionView::Base.send :include, ViewHelpers
    end
  end 
end