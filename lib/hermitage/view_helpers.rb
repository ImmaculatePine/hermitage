require 'hermitage/rails_render_core' if defined? Rails

module Hermitage
  
  module ViewHelpers

    # Renders gallery markup.
    #
    # Arguments:
    # * +objects+   Array of objects that should be rendered.
    # * +options+   Hash of options. There is list of available options in Defaults module.
    # 
    # Examples:
    #
    #   render_gallery_for @images      # @images here is array of Image instances
    #   render_gallery_for album.photos # album.photos is array of Photo instances
    #
    # it will render the objects contained in array and will use :images (or :photos) as config name.
    # Config names are formed by the class name of the first element in array.
    #
    def render_gallery_for(objects, options = {})
      RailsRenderCore.new(objects, options).render if defined? Rails
    end

  end
  
end