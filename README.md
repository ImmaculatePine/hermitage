# Hermitage

[![Build Status](https://travis-ci.org/ImmaculatePine/hermitage.png?branch=master)](https://travis-ci.org/ImmaculatePine/hermitage)
[![Code Climate](https://codeclimate.com/github/ImmaculatePine/hermitage.png)](https://codeclimate.com/github/ImmaculatePine/hermitage)

Ruby library for generation of image galleries (thumbnails and original images viewer).

## Demo

There is a [demo](http://immaculatepine.github.io/hermitage/demo/default/) with customization examples at project's [homepage](http://immaculatepine.github.io/hermitage/).

## Requirements

Hermitage requires Ruby on Rails version >= 3.2 with support of jQuery and CoffeeScript (jquery-rails and coffee-rails gems, respectively).

## Installation

Add this line to your application's Gemfile:

    gem 'hermitage'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hermitage

Also you have to run installation script to create config file and add require statement to your application.js file.

    rails generate hermitage:install

## Quick Start

Add this line to your view:

    render_gallery_for @images # or any other array of objects with image attachments

It is enough in theory.

## Usage

The example from Quick Start section works well when you are using Paperclip gem for file attachment and your model looks like this:

    class Image < ActiveRecord::Base
      attr_accessible :file
      has_attached_file :file, styles: { thumbnail: '100x100>' }
    end

Then

    render_gallery_for @images

will render markup for the gallery.

In other cases some configuration is necessary.

### Options

You can pass options hash to `render_gallery_for` method if you want to customize Hermitage behavior.

#### Specify Image Path

E.g. your `Photo` model has methods `image_full` and `image_thumb` that return path to full image and its thumbnail, respectively.
Then you can write in your view file:

    render_gallery_for @photos, original: 'image_full', thumbnail: 'image_thumb'

Then Hermitage will use the specified methods to get paths to your images and thumbnails.

If the only method returns both paths according to passed parameters you can specify it like this:

    render_gallery_for @posts, original: 'attachment(:full)', thumbnail: 'attachment(:thumbnail)'

Also you can specify those values by lambdas:

    render_gallery_for @posts, original: -> post { post.attachment(:full) }, thumbnail: -> post { post.attachment(:thumbnail) }

#### Markup

Hermitage renders markup that will look nice with Twitter Bootstrap by default:

    <ul class="thumbnails">
      <li class="span4">
        <a href="/path/to/full/image" class="thumbnail" rel="hermitage">
          <img src="/path/to/thumbnail" />
        </a>
      </li>
    </ul>

You can configure any element of this markup by overwriting `list_tag`, `item_tag`, `list_class`, `item_class`, `link_class`, `image_class` and `title` properties.

For example this line of code:

    render_gallery_for @images, list_tag: :div, item_tag: :p, item_class: 'image'

will render the following markup:

    <div class="thumbnails">
      <p class="image">
        <a href="/path/to/full/image" class="thumbnail" rel="hermitage">
          <img src="/path/to/thumbnail" />
        </a>
      </p>
    </div>

#### Specify Image Title

You can add `title` attribute to generated links by passing `title` option to `render_gallery_for` method:

    render_gallery_for @images, title: 'description' # assuming that image.description returns some text

It will render something like that:

    <div class="thumbnails">
      ...
        <a href="/path/to/full/image" class="thumbnail" rel="hermitage" title="This is photo of my cat.">
      ...

If the link has title attribute there will be bottom panel with this text when you open the gallery.

#### Slicing

If you are using Twitter Bootstrap framework and your gallery is inside `.row-fluid` block the markup above will not look awesome.
Or maybe you have any other reasons to split the gallery into several separate galleries.
Then pass `each_slice` options to `render_gallery_for` method:

    @images = Array.new(5, Image.new) # weird, but it's just an example
    render_gallery_for @images, each_slice: 3

This code will render 2 `ul` tags with 3 and 2 items in each, respectively. Nevertheless they both will be available in navigation flow when you open the image viewer.

### Configuration

It is more handy to use configs to customize Hermitage behavior.

When you call `render_gallery_for` method Hermitage looks for config with name formed by the plural form of class name of the first element in passed array.
In the example above Hermitage tries to find :images config because first argument of `render_gallery_for` method was array of Image instances.
If there is no proper config :default config is used.

Hermitage configs are described in config/initializers/hermitage.rb file. For configuration you can use DSL syntax described below.

#### Overwriting Defaults

You can overwrite :default config. These changes will be applied to all the galleries in your application.

Uncoment the following lines in config/initializers/hermitage.rb file and make some changes here:

    Hermitage.configure :default do
      original -> item { item.image.url(:medium) }
      thumbnail -> item { image.url(:small) }
    end

Now Hermitage will use `image.url` method with :medium or :small argument to get images for the gallery.

#### Custom Configs

When there are several galleries that need different markup it is better to use custom configs.

For example there are 2 models in your application:

    class Picture < ActiveRecord::Base
      def image_path(style = :large)
        # magically returns correct image url for :large and :small styles
      end
    end

and

    class Post < ActiveRecord::Base
      attr_accessible :attachment
      has_attached_file :attachment, styles: { tiny: '200x200>' }
    end

Suppose that pictures should be rendered with Twitter Bootstrap style, but posts should be wrapped by simple blocks.
Then your config/initializers/hermitage.rb could looks like this:

    # Some rules for :default config if needed...

    # Setup by lambdas...
    Hermitage.configure :pictures do
      original -> item { item.image_path }
      thumbnail -> item { item.image_path(:small) }
    end

    # ...or by strings
    Hermitage.configure :posts do
      original 'attachment'
      thumbnail 'attachment(:tiny)'
      list_tag :div
      item_tag :div
      list_class 'posts'
      item_class 'post'
    end

Now when you write `render_gallery_for @pictures` or `render_gallery_for @posts` Hermitage will automatically choose the proper config.

#### Configs Priority

You have noticed that it is not neccessary to specify every parameter in config or options block.
So, Hermitage looks for parameters with the following priority:

* It uses all parameters from default config;
* Then it overwrites some of them by custom config's parameters if they were specified;
* Finally it overwrites both of them by the values from options hash passed to `render_gallery_for` method (if there are such values, of course).

### Viewer Customization

You can customize appearance of Hermitage image viewer. All you need is to add to any of your .js or .coffee files lines like this:

    hermitage.darkening.opacity = 0
    hermitage.navigationButtons.styles = { color: '#faeedd' }

In the example above the darkening will be disabled and both navigation buttons will change their color.

You can customize the following parameters:

* `looped` - set it to false if after the last image the first should not be shown
* `preloadNeighbours` - determines if next and previous images should be preloaded
* `slideshowEffect` - how to show/hide images (correct values are 'slide' and 'fade'). Default value is 'slide'
* `darkening.opacity` - opacity of darkening layer (0 if it should be disabled)
* `darkening.styles` - any custom CSS for darkening layer
* `navigationButtons.enabled` - are there navigation buttons
* `navigationButtons.styles` - any custom CSS for both navigation buttons
* `navigationButtons.next.styles` - any custom CSS for next navigation button
* `navigationButtons.previous.styles` - any custom CSS for previous navigation button
* `navigationButtons.next.text` - text for next navigation button
* `navigationButtons.previous.text` - text for previous navigation button
* `closeButton.enabled` - is there close button
* `closeButton.text` - close button's text
* `closeButton.styles` - any custom CSS for close button
* `image.styles` - any custom CSS for current image
* `bottomPanel.styles` - any custom CSS for bottom panel
* `bottomPanel.text.styles` - any custom CSS for text block of bottom panel
* `loader.image` - custom image for loader
* `loader.timeout` - timeout before loader animation should appear
* `loader.styles` - custom styles for loader
* `minimumSize.width` - minimum width of scaled image, px
* `minimumSize.height` - minimum height of scaled image, px
* `animationDuration` - duration of UI animations, ms
* `resizeTimeout` - timeout before moving elements to the proper places after resizing, ms

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
