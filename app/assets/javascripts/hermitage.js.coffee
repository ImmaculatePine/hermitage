root = exports ? this

#
# Data
#

# Hermitage options
root.hermitage =
  # Image viewer z-index property
  z_index: 10

  # Darkening properties
  darkening:
    opacity: 0.75 # 0 if you don't want darkening
    color: "#000"

  # Navigation buttons' properties
  navigation_button:
    enabled: true
    color: "#777"
    width: 50 # px
    border_radius: 7 # px
    margin: 10 # Distance between navigation buttons and image, px

  # Close button properties
  close_button:
    enabled: true
    text: "×"
    color: "#FFF"
    font_size: 30 # px
  
  # Minimum distance between window borders and image, px
  window_padding_x: 50
  window_padding_y: 50

  # Minimum size of scaled image, px
  minimum_scaled_width: 100
  minimum_scaled_height: 100

  # Duration of all animations, ms
  animation_duration: 400


# Array of images of current gallery
root.images = []


# Initializes the gallery on this page
root.init_hermitage = ->
  # Create simple gallery layer if it doesn't exist
  if ($("#hermitage").length == 0)
    layer = $("<div>", {id: "hermitage"})
    $("body").append(layer)
    layer.css("position", "fixed")
    layer.hide()

  # Clear old images array
  images.length = 0

  # Create new images array
  $.each $('a[rel="hermitage"]'), ->
    images.push($(this).attr('href'))

  # Set on click handlers to all elements that
  # have 'hermitage' rel attribute
  $('a[rel="hermitage"]').click (event) ->
    open_gallery(this)
    event.preventDefault()

#
# Helpers
#

# Place element at the center of screen
jQuery.fn.center = () ->
  this.css("position", "fixed")
  this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px")
  this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px")
  this


#
# Simple gallery logic
#

# Creates overlay layer, shows it and sets its click handler
create_overlay = () ->
  overlay = $("<div>", {id: "overlay"})
  $("#hermitage").append(overlay)

  overlay.css("position", "fixed")
  overlay.css("top", "0")
  overlay.css("left", "0")
  overlay.css("background", hermitage.darkening.color)
  overlay.css("display", "block")
  overlay.css("opacity", hermitage.darkening.opacity)
  overlay.css("filter", "alpha(opacity=" + hermitage.darkening.opacity * 100 + ")")
  overlay.css("width", "100%")
  overlay.css("height", "100%")

  overlay.hide()
  overlay.fadeIn()

  overlay.click (event) ->
    close_gallery()

  overlay


# Creates base navigation button and returns it
create_navigation_button = () ->
  button = $("<div>")
  $("#hermitage").append(button)

  button.css("position", "fixed")
  button.css("width", hermitage.navigation_button.width + "px")
  button.css("display", "block")
  button.css("cursor", "pointer")

  button.css("border-width", "1px")
  button.css("border-style", "solid")
  button.css("border-color", hermitage.navigation_button.color)
  button.css("display", "block")
  button.css("border-radius", hermitage.navigation_button.border_radius + "px")
  button.css("-webkit-border-radius", hermitage.navigation_button.border_radius + "px")
  button.css("-moz-border-radius", hermitage.navigation_button.border_radius + "px")

  button.css("color", hermitage.navigation_button.color)
  button.css("text-align", "center")
  button.css("vertical-align", "middle")
  button.css("font", "30px Tahoma,Arial,Helvetica,sans-serif")

  button.hide()

  button

# Creates right navigation button and returns it
create_right_navigation_button = () ->
  button = create_navigation_button()
  button.attr("id", "navigation-right")
  button.css("border-top-left-radius", "0")
  button.css("-webkit-border-top-left-radius", "0")
  button.css("-moz-border-top-left-radius", "0")
  button.css("border-bottom-left-radius", "0")
  button.css("-webkit-border-bottom-left-radius", "0")
  button.css("-moz-border-bottom-left-radius", "0")
  button.append(">")

  button.click (event) ->
    show_next_image()

  button

# Create left navigation button and returns it
create_left_navigation_button = () ->
  button = create_navigation_button()
  button.attr("id", "navigation-left")
  button.css("border-top-right-radius", "0")
  button.css("-webkit-border-top-right-radius", "0")
  button.css("-moz-border-top-right-radius", "0")
  button.css("border-bottom-right-radius", "0")
  button.css("-webkit-border-bottom-right-radius", "0")
  button.css("-moz-border-bottom-right-radius", "0")
  button.append("<")

  button.click (event) ->
    show_previous_image()

  button

# Creates close button
create_close_button = () ->
  button = $("<div>", {id: "close_button"})
  $("#hermitage").append(button)

  button.hide()

  button.text(hermitage.close_button.text)
  button.css("position", "fixed")
  button.css("color", hermitage.close_button.color)
  button.css("font-size", hermitage.close_button.font_size + "px")
  button.css("white-space", "nowrap")
  button.css("cursor", "pointer")

  button.click(close_gallery)

  button

# Shows full size image of the chosen one
open_gallery = (image) ->
  $("#hermitage").css("z-index", hermitage.z_index)
  $("#hermitage").empty()
  $("#hermitage").show()
  
  create_overlay()
  create_right_navigation_button()
  create_left_navigation_button()
  create_close_button()

  show_image(images.indexOf($(image).attr("href")))
  

# Shows image with specified index from images array
show_image = (index) ->
  # Create full size image at the center of screen
  img = $("<img />")
  img.attr("src", images[index])
  img.attr("class", "current")
  img.css("cursor", "pointer")
  img.hide()
  
  $("#hermitage").append(img)
  
  img.click (event) ->
    if (event.pageX >= $(window).width() / 2)
      show_next_image()
    else
      show_previous_image()

  # When image will be loaded set correct size,
  # center element and show it
  $("<img />").attr("src", images[index]).load ->
    max_width = $(window).width() - (hermitage.window_padding_x + $("#navigation-left").outerWidth() + hermitage.navigation_button.margin) * 2
    max_height = $(window).height() - hermitage.window_padding_y * 2

    scale = 1.0

    if (max_width <= hermitage.minimum_scaled_width || max_height <= hermitage.minimum_scaled_height)
      if (max_width < max_height)
        max_width = hermitage.minimum_scaled_width
        max_height = max_width * (this.height / this.width)
      else
        max_height = hermitage.minimum_scaled_height
        max_width = max_height * (this.width / this.height)

    if (this.width > max_width || this.height > max_height)
      scale = Math.min(max_width / this.width, max_height / this.height)

    img.width(this.width * scale)
    img.height(this.height * scale)

    img.center()
    img.fadeIn(hermitage.animation_duration)
    adjust_navigation_buttons(img)
    adjust_close_button(img)

# Shows next image
show_next_image = ->
  current = $("img.current")
  if (current.length == 1)
    index = images.indexOf(current.attr("src"))
    hide_current_image()
    if (index < images.length - 1)
      show_image(index + 1)
    else
      show_image(0)

# Shows previous image
show_previous_image = ->
  current = $("img.current")
  if (current.length == 1)
    index = images.indexOf(current.attr("src"))
    hide_current_image()
    if (index > 0)
      show_image(index - 1)
    else
      show_image(images.length - 1)

# Hides current image
hide_current_image = ->
  current = $("img.current")
  if (current.length == 1)
    current.fadeOut hermitage.animation_duration, ->
      current.remove()

# Starts fade out animation and clears simple gallery at the end of animation
close_gallery = () ->
  $("#hermitage :not(#overlay)").fadeOut()
  $("#overlay").fadeOut hermitage.animation_duration, ->
    $("#hermitage").hide()
    $("#hermitage").empty()


# Moves navigation buttons to proper positions
adjust_navigation_buttons = (current) ->
  return unless hermitage.navigation_button.enabled

  left = $("#navigation-left")
  right = $("#navigation-right")

  left_new_height = current.outerHeight() + "px"
  left_new_left = (current.position().left - left.outerWidth() - hermitage.navigation_button.margin) + "px"
  left_new_top = current.position().top + "px"

  right_new_height = current.outerHeight() + "px"
  right_new_left = (current.position().left + current.outerWidth() + hermitage.navigation_button.margin) + "px"
  right_new_top = current.position().top + "px"

  left.animate({ height: left_new_height, 'line-height': left_new_height, left: left_new_left, top: left_new_top}, hermitage.animation_duration)
  right.animate({ height: right_new_height, 'line-height': right_new_height, left: right_new_left, top: right_new_top}, hermitage.animation_duration)

  left.fadeIn(hermitage.animation_duration) if (left.css("display") == "none")
  right.fadeIn(hermitage.animation_duration) if (right.css("display") == "none")

# Moves close button to proper position
adjust_close_button = (current) ->
  return unless hermitage.close_button.enabled

  button = $("#close_button")

  top = current.position().top - button.outerHeight()
  left = current.position().left + current.outerWidth() - button.outerWidth()

  if (button.css("display") == "none")
    button.css("top", top)
    button.css("left", left)
    button.fadeIn(hermitage.animation_duration) 

  button.animate({ top: top, left: left }, hermitage.animation_duration)
  

# Initialize gallery on page load
$(document).ready(init_hermitage)
$(document).on('page:load', init_hermitage)