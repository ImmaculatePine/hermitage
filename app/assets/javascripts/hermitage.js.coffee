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
    default:
      attributes:
        id: 'overlay'
      styles:
        position: 'fixed'
        top: 0
        left: 0
        width: '100%'
        height: '100%'
        backgroundColor: '#000'
        
    opacity: 0.75 # 0 if you don't want darkening
    styles: {}

  # Navigation buttons' properties
  navigationButtons:
    default:
      styles:
        position: 'fixed'
        width: '50px'
        cursor: 'pointer'
        border: '1px solid #777'
        backgroundColor: 'none'
        color: '#777'
        fontSize: '30px'
        fontFamily: 'Tahoma,Arial,Helvetica,sans-serif'
        textAlign: 'center'
        verticalAlign: 'middle'

    enabled: true
    borderRadius: 7 # px
    margin: 10 # px
    styles: {}

    next:
      default:
        attributes:
          id: 'navigation-right'
      styles: {}

    previous:
      default:
        attributes:
          id: 'navigation-left'
      styles: {}

  # Close button properties
  closeButton:
    default:
      attributes:
        id: 'close-button'
      styles:
        position: 'fixed'
        color: '#FFF'
        fontSize: '30px'
        fontFamily: 'Tahoma,Arial,Helvetica,sans-serif'
        whiteSpace: 'nowrap'
        cursor: 'pointer'
        
    enabled: true
    text: '×'
    styles: {}

  # Current image properties
  image:
    default:
      attributes:
        class: 'current'
      styles:
        cursor: 'pointer'
        maxWidth: 'none' # Fix the conflict with Twitter Bootstrap

    styles: {}
  
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
      $('<div>')
        .attr('id', 'hermitage')
        .css('position', 'fixed')
        .hide()
        .appendTo($('body'))

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

# Sets border-radius, -webkit-border-radius and -moz-border-radius CSS properties
$.fn.borderRadius = (value, type = '') ->
  property = "border-#{type}#{if !!type then '-' else ''}radius"
  this.css(property, value)
      .css("-webkit-#{property}", value)
      .css("-moz-#{property}", value)

#
# Hermitage logic
#

# Creates darkening overlay, shows it and sets its click handler
createDarkening = ->
  $('<div>')
    .attr(hermitage.darkening.default.attributes)
    .css(hermitage.darkening.default.styles)
    .css('opacity', hermitage.darkening.opacity)
    .css('filter', "alpha(opacity='#{hermitage.darkening.opacity * 100}')")
    .css(hermitage.darkening.styles)
    .appendTo($('#hermitage'))
    .hide()
    .fadeIn()
    .click(closeGallery)

# Creates base navigation button and returns it
createNavigationButton = ->
  $('<div>')
    .css(hermitage.navigationButtons.default.styles)
    .borderRadius("#{hermitage.navigationButtons.borderRadius}px")
    .hide()
    .appendTo($('#hermitage'))
    .css(hermitage.navigationButtons.styles)

# Creates right navigation button and returns it
createRightNavigationButton = ->
  createNavigationButton()
    .attr(hermitage.navigationButtons.next.default.attributes)
    .borderRadius('0', 'top-left')
    .borderRadius('0', 'bottom-left')
    .text('>')
    .css(hermitage.navigationButtons.next.styles)
    .click(showNextImage)

# Create left navigation button and returns it
createLeftNavigationButton = ->
  createNavigationButton()
    .attr(hermitage.navigationButtons.previous.default.attributes)
    .borderRadius('0', 'top-right')
    .borderRadius('0', 'bottom-right')
    .text('<')
    .css(hermitage.navigationButtons.previous.styles)
    .click(showPreviousImage)

# Creates close button
createCloseButton = ->
  $('<div>')
    .attr(hermitage.closeButton.default.attributes)
    .css(hermitage.closeButton.default.styles)
    .text(hermitage.closeButton.text)
    .css(hermitage.closeButton.styles)
    .hide()
    .appendTo($('#hermitage'))
    .click(closeGallery)

# Shows full size image of the chosen one
openGallery = (image) ->
  $('#hermitage')
    .css('z-index', hermitage.zIndex)
    .empty()
    .show()
  
  createDarkening()
  createRightNavigationButton()
  createLeftNavigationButton()
  createCloseButton()

  showImage(hermitage.images.indexOf($(image).attr('href')))
  

# Shows image with specified index from images array
showImage = (index) ->
  # Create full size image at the center of screen
  img = $('<img />')
    .attr(hermitage.image.default.attributes)
    .css(hermitage.image.default.styles)
    .attr('src', hermitage.images[index])
    .css(hermitage.image.styles)
    .hide()
    .appendTo($('#hermitage'))
  
  img.click (event) ->
    if event.pageX >= $(window).width() / 2
      showNextImage()
    else
      showPreviousImage()

  # When image will be loaded set correct size,
  # center element and show it
  $('<img />').attr('src', hermitage.images[index]).load ->
    maxWidth = $(window).width() - (hermitage.windowPadding.x + $('#navigation-left').outerWidth() + hermitage.navigationButtons.margin) * 2
    maxHeight = $(window).height() - hermitage.windowPadding.y * 2

    if maxWidth <= hermitage.minimumSize.width or maxHeight <= hermitage.minimumSize.height
      if maxWidth < maxHeight
        maxWidth = hermitage.minimumSize.width
        maxHeight = maxWidth * (this.height / this.width)
      else
        maxHeight = hermitage.minimumSize.height
        maxWidth = maxHeight * (this.width / this.height)

    scale = 1.0

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
  return unless hermitage.navigationButtons.enabled

  previous = $('#hermitage #navigation-left')
  next = $('#hermitage #navigation-right')

  newPrevious = 
    top: current.position().top
    left: current.position().left - previous.outerWidth() - hermitage.navigationButtons.margin
    height: current.outerHeight()
  
  newNext = 
    top: current.position().top
    left: current.position().left + current.outerWidth() + hermitage.navigationButtons.margin
    height: current.outerHeight()

  move = (button, dimensions) ->
    animation =
      height: "#{dimensions.height}px"
      lineHeight: "#{dimensions.height}px"
      left: "#{dimensions.left}px"
      top: "#{dimensions.top}px"
    button.animate(animation, hermitage.animationDuration)
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