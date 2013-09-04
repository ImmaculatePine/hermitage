# Configuration file for hermitage gem

# Default config is used as base options hash for every gallery.
# You can configure any of its options and they will be applied for every rendering.
#
# Hermitage.configs[:default].merge!({
#   attribute_full_size: 'file.url',
#   attribute_thumbnail: 'file.url(:thumbnail)',
#   list_tag: :ul,
#   item_tag: :li,
#   list_class: 'thumbnails',
#   item_class: 'span4',
#   link_class: 'thumbnail',
#   image_class: nil,
#   each_slice: nil
# })

# Also you can create your own configs that will be merged with default config to overwrite default options.
#
# E.g. when you write
#
#   render_gallery_for @images
#
# :images config will be used.
#
# All available options are listed in default config above.
#
# Hermitage.configs[:images] = {

# }