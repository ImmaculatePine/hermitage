root = exports ? this

#
# Data
#

# Hermitage options
root.hermitage =
  # Image viewer z-index property
  zIndex: 10

  # Darkening properties
  darkening:
    opacity: 0.75 # 0 if you don't want darkening
    color: '#000'

  # Navigation buttons' properties
  navigationButton:
    enabled: true
    width: 50 # px
    fontSize: 30 # px
    fontFamily: 'Tahoma,Arial,Helvetica,sans-serif'
    color: '#777'
    backgroundColor: 'none'
    borderColor: '#777'
    borderRadius: 7 # px
    margin: 10 # Distance between navigation buttons and image, px

  # Close button properties
  closeButton:
    enabled: true
    text: '×'
    color: '#FFF'
    fontSize: 30 # px
    fontFamily: 'Tahoma,Arial,Helvetica,sans-serif'
  
  # Minimum distance between window borders and image, px
  windowPadding:
    x: 50
    y: 50

  # Minimum size of scaled image, px
  minimumSize:
    width: 100
    height: 100

  # Duration of all animations, ms
  animationDuration: 400

  # Array of images of current gallery
  images: []

  # Initializes the gallery on this page
  init: ->
    # Create Hermitage layer if it doesn't exist
    if $('#hermitage').length is 0
      layer = $('<div>', {id: 'hermitage'})
      layer.css('position', 'fixed')
      layer.hide()
      $('body').append(layer)

    # Clear old images array
    hermitage.images.length = 0

    # Create new images array
    $.each $('a[rel="hermitage"]'), ->
      hermitage.images.push($(this).attr('href'))

    # Set on click handlers to all elements that
    # have 'hermitage' rel attribute
    $('a[rel="hermitage"]').click (event) ->
      openGallery(this)
      event.preventDefault()

#
# Helpers
#

# Place element at the center of screen
$.fn.center = ->
  this.css('position', 'fixed')
      .css('top', "#{Math.max(0, ($(window).height() - $(this).outerHeight()) / 2)}px")
      .css('left', "#{Math.max(0, ($(window).width() - $(this).outerWidth()) / 2)}px")
  this

# Sets border-radius, -webkit-border-radius and -moz-border-radius CSS properties
$.fn.borderRadius = (value, type = '') ->
  property = "border-#{type}#{if !!type then '-' else ''}radius"
  this.css(property, value)
      .css("-webkit-#{property}", value)
      .css("-moz-#{property}", value)
  this

#
# Hermitage logic
#

# Creates overlay layer, shows it and sets its click handler
createOverlay = ->
  overlay = $('<div>', {id: 'overlay'})
  $('#hermitage').append(overlay)

  overlay.css('position', 'fixed')
         .css('top', '0')
         .css('left', '0')
         .css('background', hermitage.darkening.color)
         .css('opacity', hermitage.darkening.opacity)
         .css('filter', "alpha(opacity='#{hermitage.darkening.opacity * 100}')")
         .css('width', '100%')
         .css('height', '100%')
         .hide()
 
  overlay.fadeIn()

  overlay.click(closeGallery)

  overlay

# Creates base navigation button and returns it
createNavigationButton = ->
  button = $('<div>')
  $('#hermitage').append(button)

  button.css('position', 'fixed')
        .css('width', "#{hermitage.navigationButton.width}px")
        .css('cursor', 'pointer')
        .css('background-color', hermitage.navigationButton.backgroundColor)

        .css('border-width', '1px')
        .css('border-style', 'solid')
        .css('border-color', hermitage.navigationButton.borderColor)

        .borderRadius("#{hermitage.navigationButton.borderRadius}px")

        .css('color', hermitage.navigationButton.color)
        .css('text-align', 'center')
        .css('vertical-align', 'middle')
        .css('font-size', "#{hermitage.navigationButton.fontSize}px")
        .css('font-family', hermitage.navigationButton.fontFamily)

        .hide()

  button

# Creates right navigation button and returns it
createRightNavigationButton = ->
  button = createNavigationButton()
  button.attr('id', 'navigation-right')
        .borderRadius('0', 'top-left')
        .borderRadius('0', 'bottom-left')
        .text('>')

  button.click(showNextImage)

  button

# Create left navigation button and returns it
createLeftNavigationButton = ->
  button = createNavigationButton()
  button.attr('id', 'navigation-left')
        .borderRadius('0', 'top-right')
        .borderRadius('0', 'bottom-right')
        .text('<')

  button.click(showPreviousImage)

  button

# Creates close button
createCloseButton = ->
  button = $('<div>', {id: 'close-button'})
  $('#hermitage').append(button)

  button.text(hermitage.closeButton.text)
        .css('position', 'fixed')
        .css('color', hermitage.closeButton.color)
        .css('font-size', "#{hermitage.closeButton.fontSize}px")
        .css('font-family',hermitage.closeButton.fontFamily)
        .css('white-space', 'nowrap')
        .css('cursor', 'pointer')
        .hide()

  button.click(closeGallery)

  button

# Shows full size image of the chosen one
openGallery = (image) ->
  $('#hermitage').css('z-index', hermitage.zIndex)
  $('#hermitage').empty()
  $('#hermitage').show()
  
  createOverlay()
  createRightNavigationButton()
  createLeftNavigationButton()
  createCloseButton()

  showImage(hermitage.images.indexOf($(image).attr('href')))
  

# Shows image with specified index from images array
showImage = (index) ->
  # Create full size image at the center of screen
  img = $('<img />')
  img.attr('src', hermitage.images[index])
     .attr('class', 'current')
     .css('cursor', 'pointer')
     .css('max-width', 'none') # fix the conflict with TWitter Bootstrap
     .hide()
  
  $('#hermitage').append(img)
  
  img.click (event) ->
    if event.pageX >= $(window).width() / 2
      showNextImage()
    else
      showPreviousImage()

  # When image will be loaded set correct size,
  # center element and show it
  $('<img />').attr('src', hermitage.images[index]).load ->
    maxWidth = $(window).width() - (hermitage.windowPadding.x + $('#navigation-left').outerWidth() + hermitage.navigationButton.margin) * 2
    maxHeight = $(window).height() - hermitage.windowPadding.y * 2

    scale = 1.0

    if maxWidth <= hermitage.minimumSize.width or maxHeight <= hermitage.minimumSize.height
      if maxWidth < maxHeight
        maxWidth = hermitage.minimumSize.width
        maxHeight = maxWidth * (this.height / this.width)
      else
        maxHeight = hermitage.minimumSize.height
        maxWidth = maxHeight * (this.width / this.height)

    if this.width > maxWidth or this.height > maxHeight
      scale = Math.min(maxWidth / this.width, maxHeight / this.height)

    img.width(this.width * scale)
       .height(this.height * scale)
       .center()
       .fadeIn(hermitage.animationDuration)
    
    adjustNavigationButtons(img)
    adjustCloseButton(img)

# Shows next image
showNextImage = ->
  current = $('img.current')
  if current.length is 1
    index = hermitage.images.indexOf(current.attr('src'))
    hideCurrentImage()
    if index < hermitage.images.length - 1
      showImage(index + 1)
    else
      showImage(0)

# Shows previous image
showPreviousImage = ->
  current = $('img.current')
  if current.length is 1
    index = hermitage.images.indexOf(current.attr('src'))
    hideCurrentImage()
    if index > 0
      showImage(index - 1)
    else
      showImage(hermitage.images.length - 1)

# Hides current image
hideCurrentImage = ->
  current = $('img.current')
  if current.length is 1
    current.fadeOut hermitage.animationDuration, ->
      current.remove()

# Starts fade out animation and clears Hermitage at the end of animation
closeGallery = ->
  $('#hermitage :not(#overlay)').fadeOut()
  $('#overlay').fadeOut hermitage.animationDuration, ->
    $('#hermitage').hide()
                   .empty()


# Moves navigation buttons to proper positions
adjustNavigationButtons = (current) ->
  return unless hermitage.navigationButton.enabled

  previous = $('#hermitage #navigation-left')
  next = $('#hermitage #navigation-right')

  newPrevious = 
    top: current.position().top
    left: current.position().left - previous.outerWidth() - hermitage.navigationButton.margin
    height: current.outerHeight()
  
  newNext = 
    top: current.position().top
    left: current.position().left + current.outerWidth() + hermitage.navigationButton.margin
    height: current.outerHeight()

  move = (button, dimensions) ->
    button.animate({ height: "#{dimensions.height}px", 'line-height': "#{dimensions.height}px", left: "#{dimensions.left}px", top: "#{dimensions.top}px"}, hermitage.animationDuration)    
    button.fadeIn(hermitage.animationDuration) if button.css('display') is 'none'

  move previous, newPrevious
  move next, newNext

# Moves close button to proper position
adjustCloseButton = (current) ->
  return unless hermitage.closeButton.enabled

  button = $('#hermitage #close-button')

  top = current.position().top - button.outerHeight()
  left = current.position().left + current.outerWidth() - button.outerWidth()

  if button.css('display') is 'none'
    button.css('top', top)
          .css('left', left)
          .fadeIn(hermitage.animationDuration)

  button.animate({ top: "#{top}px", left: "#{left}px" }, hermitage.animationDuration)
  

# Initialize gallery on page load
$(document).ready(hermitage.init)
$(document).on('page:load', hermitage.init)