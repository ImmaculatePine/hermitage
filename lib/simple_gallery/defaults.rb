module SimpleGallery
  module Defaults
    # Model's attribute (or method) that returns the path to the full size image
    ATTRIBUTE_FULL_SIZE = 'file.url'

    # Model's attribute (or method) that returns the path to the image's thumbnail
    ATTRIBUTE_THUMBNAIL = 'file.url(:thumbnail)'

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