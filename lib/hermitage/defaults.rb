module Hermitage
  module Defaults
    # Model's attribute (or method) that returns the path to the original image
    ORIGINAL = 'file.url'

    # Model's attribute (or method) that returns the path to the image's thumbnail
    THUMBNAIL = 'file.url(:thumbnail)'

    # Model's attribute (or method) that returns title or description of image
    TITLE = nil

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

    # Slices each N images into the separate gallery.
    # It is helpful e.g. when using Twitter Bootstrap framework
    # and your gallery is inside `.row-fluid` block.
    EACH_SLICE = nil

    # Each gallery item can have its own checkbox.
    # We can manipulate with photos through javascript.
    WITH_CHECKBOXES = false
    CHECKBOX_NAME = :photo_check
    CHECKBOX_VALUE_ATTRIBUTE = :id

    # You can show visible title under the photo
    WITH_PHOTO_TITLE = false

    # Each photo can belong to a folder.
    WITH_FOLDER_LINKS = false
    FOLDER_ASSOCIATION_NAME = :folder
    FOLDER_LINK_CLASS = :heading

    # Returns hash of default options
    def self.to_hash
      hash = {}
      Hermitage::Defaults.constants.each do |c|
        hash[c.downcase.to_sym] = Hermitage::Defaults.const_get(c)
      end
      hash
    end
  end
end