module Hermitage
  
  module ViewHelpers

    # Renders gallery markup as unordered list of links to full-size images.
    # Parameters:
    # * objects   Array of objects that should be rendered
    # * options   Hash of options. There is list of available options in Defaults module.
    # 
    def render_gallery_for(objects, options = {})
      options = Hermitage.configs[:default].merge(options)
      
      items = []
      objects.each do |object|
        full_image_path = object.instance_eval(options[:attribute_full_size])
        thumbnail_image_path = object.instance_eval(options[:attribute_thumbnail])
        image = image_tag(thumbnail_image_path, class: options[:image_class])
        items << link_to(image, full_image_path, rel: 'hermitage', class: options[:link_class])
      end
      
      content_tag options[:list_tag], class: options[:list_class] do
        items.collect { |item| concat(content_tag(options[:item_tag], item, class: options[:item_class])) }
      end
    end

  end
  
end