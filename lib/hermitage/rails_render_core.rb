module Hermitage
  
  # This class performs all the rendering logic for Rails apps
  class RailsRenderCore

    def initialize(objects, options = {})
      @objects = objects
      @options = Configurator.options_for(objects, options)
      @template = ActionView::Base.new
    end

    # Renders gallery markup
    def render
      # Initialize the resulting tag
      tag = ''

      # Slice objects into separate lists
      lists = slice_objects

      # Render each list into `tag` variable
      lists.each do |list|
        items = list.collect { |item| render_link_for(item) }
        tag << render_content_tag_for(items)
      end

      tag.html_safe
    end

    private

    # Slices objects into separate lists if it's necessary
    def slice_objects
      unless @options[:each_slice]
        [@objects]
      else
        @objects.each_slice(@options[:each_slice]).to_a
      end
    end

    # Returns value of item's attribute
    def value_for(item, option)
      attribute = @options[option]
      if attribute.is_a? Proc
        attribute.call(item)
      else
        eval("item.#{attribute}")
      end
    end

    # Renders link to the specific image in a gallery
    def render_link_for(item)
      original_path = value_for(item, :original)
      thumbnail_path = value_for(item, :thumbnail)
      title = @options[:title] ? value_for(item, :title) : nil
      image = @template.image_tag(thumbnail_path, class: @options[:image_class])
      @template.link_to(image, original_path, rel: 'hermitage', class: @options[:link_class], title: title)
    end

    # Renders items into content tag
    def render_content_tag_for(items)
      @template.content_tag(@options[:list_tag], class: @options[:list_class]) do
        items.collect { |item| @template.concat(@template.content_tag(@options[:item_tag], item, class: @options[:item_class])) }
      end
    end

  end

end