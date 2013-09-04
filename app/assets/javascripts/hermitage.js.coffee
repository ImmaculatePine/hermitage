root = exports ? this

#
# Data
#

# Array of images of current gallery
root.images = []

# Distance between navigation buttons and image
root.navigation_button_margin = 10

# Color of navigation button's border and symbols
root.navigation_button_color = "#777"

# Minimum distance between window borders and image
root.window_padding_x = 50
root.window_padding_y = 50

# Minimum size of scaled image
root.minimum_scaled_width = 100
root.minimum_scaled_height = 100

# Initializes the gallery on this page
root.init_hermitage = ->
  # Create simple gallery layer if it doesn't exist
  if ($("#hermitage").length == 0)
    hermitage = $("<div>", {id: "hermitage"})
    $("body").append(hermitage)
    hermitage.css("z-index", 10)
    hermitage.hide()

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
  overlay.css("background", "#000")
  overlay.css("display", "block")
  overlay.css("opacity", "0.75")
  overlay.css("filter", "alpha(opacity=75)")
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
  button.css("width", "50px")
  button.css("display", "block")
  button.css("cursor", "pointer")

  button.css("border-width", "1px")
  button.css("border-style", "solid")
  button.css("border-color", navigation_button_color)
  button.css("display", "block")
  button.css("border-radius", "7px")
  button.css("-webkit-border-radius", "7px")
  button.css("-moz-border-radius", "7px")

  button.css("color", navigation_button_color)
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


# Shows full size image of the chosen one
open_gallery = (image) ->
  $("#hermitage").empty()
  $("#hermitage").show()
  create_overlay()
  create_right_navigation_button()
  create_left_navigation_button()

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
    max_width = $(window).width() - (window_padding_x + $("#navigation-left").outerWidth() + navigation_button_margin) * 2
    max_height = $(window).height() - window_padding_y * 2

    scale = 1.0

    if (max_width <= minimum_scaled_width || max_height <= minimum_scaled_height)
      if (max_width < max_height)
        max_width = minimum_scaled_width
        max_height = max_width * (this.height / this.width)
      else
        max_height = minimum_scaled_height
        max_width = max_height * (this.width / this.height)

    if (this.width > max_width || this.height > max_height)
      scale = Math.min(max_width / this.width, max_height / this.height)

    img.width(this.width * scale)
    img.height(this.height * scale)

    img.center()
    img.fadeIn()
    adjust_navigation_buttons()

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
    current.attr("class", "")
    current.fadeOut 400, ->
      current.remove()

# Starts fade out animation and clears simple gallery at the end of animation
close_gallery = () ->
  $("#hermitage :not(#overlay)").fadeOut()
  $("#overlay").fadeOut 400, ->
    $("#hermitage").hide()
    $("#hermitage").empty()


# Moves navigation buttons to proper positions
adjust_navigation_buttons = () ->
  left = $("#navigation-left")
  right = $("#navigation-right")

  current = $(".current")

  left_new_height = current.outerHeight() + "px"
  left_new_left = (current.position().left - left.outerWidth() - navigation_button_margin) + "px"
  left_new_top = current.position().top + "px"

  right_new_height = current.outerHeight() + "px"
  right_new_left = (current.position().left + current.outerWidth() + navigation_button_margin) + "px"
  right_new_top = current.position().top + "px"

  left.animate({ height: left_new_height, 'line-height': left_new_height, left: left_new_left, top: left_new_top}, 400)
  right.animate({ height: right_new_height, 'line-height': right_new_height, left: right_new_left, top: right_new_top}, 400)

  left.fadeIn() if (left.css("display") == "none")
  right.fadeIn() if (right.css("display") == "none")

# Initialize gallery on page load
$(document).ready(init_hermitage)
$(document).on('page:load', init_hermitage)