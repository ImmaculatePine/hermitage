### 0.0.6 ###

* Fixed centering of image viewer in iOS Safari.

### 0.0.5 ###

* Loading animation added
* Original, thumbnail and title options can be lambdas
* Bug with looped gallery with the only one image fixed
* Wrong behavior with Turbolinks when user clicks back in browser fixed

### 0.0.4.1 ###

* RailsRenderCore is not a child of ActionView::Base anymore

### 0.0.4 ###

* Ability to preload neighbour images
* Slide effect added and is used by default
* Nice DSL syntax added for configuration

### 0.0.3 ###

* *Attention*! In this version some options were renamed: attribute_full_size -> original, attribute_thumbnail -> thumbnail.
* Added more viewer customization options
* Ability to set any custom CSS for any viewer element
* Ability to enable or disable looped navigation
* More neat navigation buttons
* Adjust viewer on window resize
* Bottom panel added. Now you can set image descriptions by passing `title` option to `render_gallery_for` method or config.

### 0.0.2.1 ###

* Fixed conflict with Twitter Bootstrap in Firefox and Opera.

### 0.0.2 ###

* Added ability to split the gallery into several parts by `each_slice` option 
* Added ability to customize image viewer appearance
* Close button added to the image viewer
* Fixed bug when image was incorrectly positioned because of scroll
* Removed raising exception when the first argument in `render_gallery_for` method is not Array
* Fixed the way of the image path evaluation
* CoffeeScript code refactoring

### 0.0.1 ###

The first release.