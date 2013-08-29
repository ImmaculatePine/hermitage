module SimpleGallery
  
  module ViewHelpers

    # Renders gallery markup as unordered list of links to full-size images.
    # Parameters:
    # * objects   Array of objects that should be rendered
    # * options   Hash of options
    #
    # There are next options available:
    # * attribute
    # TODO: Use the attribute option.
    # TODO: Think about other available options.
    def render_gallery(objects, options = default_options)
      items = []
      objects.each do |object|
        full_image = object.send('image')
        thumbnail_image = object.send('image', 'thumb')
        items << link_to(image_tag(thumbnail_image), full_image)
      end
      
      content_tag :ul do
        items.collect { |item| concat(content_tag(:li, item)) }
      end
    end

    private

    # Get default options hash
    # TODO: Maybe it would be better to move this somewhere else
    def default_options
      {
        attribute: 'image'
      }
    end
  end
  
end