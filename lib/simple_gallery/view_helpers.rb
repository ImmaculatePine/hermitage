module SimpleGallery
  
  module ViewHelpers

    # Renders gallery markup as unordered list of links to full-size images.
    # Parameters:
    # * objects   Array of objects that should be rendered
    # * options   Hash of options. There is list of available options in Defaults module.
    # 
    def render_gallery_for(objects, options = {})
      options = SimpleGallery.setups[:default].merge(options)
      
      items = []
      objects.each do |object|
        full_image = object.instance_eval(options[:attribute_full_size])
        thumbnail_image = object.instance_eval(options[:attribute_thumbnail])
        items << link_to(image_tag(thumbnail_image), full_image, rel: 'simple_gallery')
      end
      
      content_tag :ul do
        items.collect { |item| concat(content_tag(:li, item)) }
      end
    end

  end
  
end