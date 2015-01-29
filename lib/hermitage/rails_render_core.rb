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
        tag << render_content_tag_for(items, list)
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
    def render_content_tag_for(items, list_of_models)
      @template.content_tag(@options[:list_tag], class: @options[:list_class]) do
        items.each_with_index.map do |item, index|
          t = @template.content_tag(@options[:item_tag], class: @options[:item_class]) do
            ret = ''.html_safe
            ret << render_checkbox(list_of_models[index]) if @options[:with_checkboxes]
            ret << item
            ret << render_folder_link(value_for(list_of_models[index], @options[:folder_association_name])) if @options[:with_folder_links]
            ret << render_photo_title(list_of_models[index]) if @options[:with_photo_title]
            ret
          end
          @template.concat(t)
        end
      end
    end

    def render_folder_link(folder)
      link_to(value_for(photo, :title), url_for(folder), class: @options[:folder_link_class])
    end

    def render_checkbox(model)
      check_box_tag(@options[:checkbox_name], value_for(model, @options[:checkbox_value_attribute])).html_safe
    end

    def render_photo_title(photo)
      "<p class='#{@options[:title_class]}'>#{value_for photo, :title}</p>".html_safe
    end
  end
end