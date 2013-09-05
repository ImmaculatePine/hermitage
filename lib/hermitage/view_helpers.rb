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
      # Choose config accoring to class name of objects in passed array
      config_name = objects.first.class.to_s.pluralize.underscore.to_sym if defined?(Rails) && !objects.empty?
      config = Hermitage.configs.include?(config_name) ? config_name : :default
      
      # Merge default options with the chosen config and with passed options
      options = Hermitage.configs[:default].merge(Hermitage.configs[config]).merge(options)
      
      # Create array of all list tags
      lists = unless options[:each_slice]
        [objects]
      else
        objects.each_slice(options[:each_slice]).to_a
      end

      # The resulting tag
      tag = ''

      # Render each list into `tag` variable
      lists.each do |list|
        # Array of items in current list
        items = list.collect do |item|
          full_image_path = eval("item.#{options[:attribute_full_size]}")
          thumbnail_image_path = eval("item.#{options[:attribute_thumbnail]}")
          image = image_tag(thumbnail_image_path, class: options[:image_class])
          link_to(image, full_image_path, rel: 'hermitage', class: options[:link_class])
        end
        
        # Convert these items into content tag string
        tag << content_tag(options[:list_tag], class: options[:list_class]) do
          items.collect { |item| concat(content_tag(options[:item_tag], item, class: options[:item_class])) }
        end
      end

      tag.html_safe
    end

  end
  
end