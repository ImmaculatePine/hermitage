module SimpleGallery
  module Defaults
    # Model's attribute (or method) that returns the path to the full size image
    ATTRIBUTE_FULL_SIZE = 'file.url'

    # Model's attribute (or method) that returns the path to the image's thumbnail
    ATTRIBUTE_THUMBNAIL = 'file.url(:thumbnail)'

    # Wrapper for the whole gallery
    LIST_TAG = :ul

    # Wrapepr for each gallery item
    ITEM_TAG = :li

    # CSS classes for elements of markup
    # (defaults are for pretty look with Twitter Bootstrap)
    LIST_CLASS = 'thumbnails'
    ITEM_CLASS = 'span4'
    LINK_CLASS = 'thumbnail'
    IMAGE_CLASS = nil

    # Returns hash of default options
    def self.to_hash
      hash = {}
      SimpleGallery::Defaults.constants.each do |c|
        hash[c.downcase.to_sym] = SimpleGallery::Defaults.const_get(c)
      end
      hash
    end
  end
end