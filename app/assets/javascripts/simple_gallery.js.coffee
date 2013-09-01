root = exports ? this

#
# Data
#

# Array of images of current gallery
root.images = []

# Distance between navigation buttons and image
root.navigation_button_margin = 10

# Initializes the gallery on this page
root.init_simple_gallery = ->
  # Create simple gallery layer if it doesn't exist
  if ($("#simple_gallery").length == 0)
    simpleGallery = $("<div>", {id: "simple_gallery"})
    $("body").append(simpleGallery)
    simpleGallery.css("z-index", 10)
    simpleGallery.hide()

  # Clear old images array
  images.length = 0

  # Create new images array
  $.each $('a[rel="simple_gallery"]'), ->
    images.push($(this).attr('href'))

  # Set on click handlers to all elements that
  # have 'simple_gallery' rel attribute
  $('a[rel="simple_gallery"]').click (event) ->
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
  $("#simple_gallery").append(overlay)

  overlay.css("position", "fixed")
  overlay.css("top", "0")
  overlay.css("left", "0")
  overlay.css("background", "black")
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
  $("#simple_gallery").append(button)

  button.css("position", "fixed")
  button.css("width", "50px")
  button.css("display", "block")
  button.css("cursor", "pointer")

  button.css("background", "#EEE")
  button.css("display", "block")
  button.css("opacity", "0.7")
  button.css("filter", "alpha(opacity=70)")
  button.css("border-radius", "7px")
  button.css("-webkit-border-radius", "7px")
  button.css("-moz-border-radius", "7px")

  button.css("color", "#000")
  button.css("text-align", "center")
  button.css("vertical-align", "middle")
  button.css("font", "30px Tahoma,Arial,Helvetica,sans-serif")

  button.hide()

  button

# Creates right navigation button and returns it
create_right_navigation_button = () ->
  button = create_navigation_button()
  button.attr("id", "navigation-right")
  button.append(">")

  button.click (event) ->
    show_next_image()

  button

# Create left navigation button and returns it
create_left_navigation_button = () ->
  button = create_navigation_button()
  button.attr("id", "navigation-left")
  button.append("<")

  button.click (event) ->
    show_previous_image()

  button


# Shows full size image of the chosen one
open_gallery = (image) ->
  $("#simple_gallery").empty()
  $("#simple_gallery").show()
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
  
  $("#navigation-left").fadeOut()
  $("#navigation-right").fadeOut()

  $("#simple_gallery").append(img)
  
  img.click (event) ->
    if (event.pageX >= $(window).width() / 2)
      show_next_image()
    else
      show_previous_image()

  # When image will be loaded set correct size,
  # center element and show it
  $("<img />").attr("src", images[index]).load ->
    img.width(this.width)
    img.height(this.height)
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
    current.fadeOut 400, ->
      current.remove()

# Starts fade out animation and clears simple gallery at the end of animation
close_gallery = () ->
  $("#simple_gallery :not(#overlay)").fadeOut()
  $("#overlay").fadeOut 400, ->
    $("#simple_gallery").hide()
    $("#simple_gallery").empty()


# Moves navigation buttons to proper positions
adjust_navigation_buttons = () ->
  left = $("#navigation-left")
  right = $("#navigation-right")

  current = $(".current")

  left.css("height", current.outerHeight() + "px")
  left.css("line-height", current.outerHeight() + "px")
  left.css("left", (current.position().left - left.outerWidth() - navigation_button_margin) + "px")
  left.css("top", current.position().top + "px")
  
  right.css("height", current.outerHeight() + "px")
  right.css("line-height", current.outerHeight() + "px")
  right.css("left", (current.position().left + current.outerWidth() + navigation_button_margin) + "px")
  right.css("top", current.position().top + "px")

  left.fadeIn()
  right.fadeIn()

# Initialize gallery on page load
$(document).ready(init_simple_gallery)
$(document).on('page:load', init_simple_gallery)