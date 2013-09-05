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
    color: '#777'
    width: 50 # px
    borderRadius: 7 # px
    margin: 10 # Distance between navigation buttons and image, px

  # Close button properties
  closeButton:
    enabled: true
    text: '×'
    color: '#FFF'
    fontSize: 30 # px
  
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
center = (element) ->
  element.css('position', 'fixed')
  element.css('top', "#{Math.max(0, ($(window).height() - $(element).outerHeight()) / 2)}px")
  element.css('left', "#{Math.max(0, ($(window).width() - $(element).outerWidth()) / 2)}px")
  element

#
# Hermitage logic
#

# Creates overlay layer, shows it and sets its click handler
createOverlay = ->
  overlay = $('<div>', {id: 'overlay'})
  $('#hermitage').append(overlay)

  overlay.css('position', 'fixed')
  overlay.css('top', '0')
  overlay.css('left', '0')
  overlay.css('background', hermitage.darkening.color)
  overlay.css('display', 'block')
  overlay.css('opacity', hermitage.darkening.opacity)
  overlay.css('filter', "alpha(opacity='#{hermitage.darkening.opacity * 100}')")
  overlay.css('width', '100%')
  overlay.css('height', '100%')

  overlay.hide()
  overlay.fadeIn()

  overlay.click(closeGallery)

  overlay

# Creates base navigation button and returns it
createNavigationButton = ->
  button = $('<div>')
  $('#hermitage').append(button)

  button.css('position', 'fixed')
  button.css('width', "#{hermitage.navigationButton.width}px")
  button.css('display', 'block')
  button.css('cursor', 'pointer')

  button.css('border-width', '1px')
  button.css('border-style', 'solid')
  button.css('border-color', hermitage.navigationButton.color)
  button.css('display', 'block')
  button.css('border-radius', "#{hermitage.navigationButton.borderRadius}px")
  button.css('-webkit-border-radius', "#{hermitage.navigationButton.borderRadius}px")
  button.css('-moz-border-radius', "#{hermitage.navigationButton.borderRadius}px")

  button.css('color', hermitage.navigationButton.color)
  button.css('text-align', 'center')
  button.css('vertical-align', 'middle')
  button.css('font', '30px Tahoma,Arial,Helvetica,sans-serif')

  button.hide()

  button

# Creates right navigation button and returns it
createRightNavigationButton = ->
  button = createNavigationButton()
  button.attr('id', 'navigation-right')
  button.css('border-top-left-radius', '0')
  button.css('-webkit-border-top-left-radius', '0')
  button.css('-moz-border-top-left-radius', '0')
  button.css('border-bottom-left-radius', '0')
  button.css('-webkit-border-bottom-left-radius', '0')
  button.css('-moz-border-bottom-left-radius', '0')
  button.append('>')

  button.click(showNextImage)

  button

# Create left navigation button and returns it
createLeftNavigationButton = ->
  button = createNavigationButton()
  button.attr('id', 'navigation-left')
  button.css('border-top-right-radius', '0')
  button.css('-webkit-border-top-right-radius', '0')
  button.css('-moz-border-top-right-radius', '0')
  button.css('border-bottom-right-radius', '0')
  button.css('-webkit-border-bottom-right-radius', '0')
  button.css('-moz-border-bottom-right-radius', '0')
  button.append('<')

  button.click(showPreviousImage)

  button

# Creates close button
createCloseButton = ->
  button = $('<div>', {id: 'close-button'})
  $('#hermitage').append(button)

  button.hide()

  button.text(hermitage.closeButton.text)
  button.css('position', 'fixed')
  button.css('color', hermitage.closeButton.color)
  button.css('font-size', "#{hermitage.closeButton.fontSize}px")
  button.css('white-space', 'nowrap')
  button.css('cursor', 'pointer')

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
  img.attr('class', 'current')
  img.css('cursor', 'pointer')
  img.css('max-width', 'none') # fix the conflict with Twitter Bootstrap
  img.hide()
  
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
    img.height(this.height * scale)

    center(img)
    img.fadeIn(hermitage.animationDuration)
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
    $('#hermitage').empty()


# Moves navigation buttons to proper positions
adjustNavigationButtons = (current) ->
  return unless hermitage.navigationButton.enabled

  previous = $('#navigation-left')
  next = $('#navigation-right')

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

  button = $('#close-button')

  top = current.position().top - button.outerHeight()
  left = current.position().left + current.outerWidth() - button.outerWidth()

  if button.css('display') is 'none'
    button.css('top', top)
    button.css('left', left)
    button.fadeIn(hermitage.animationDuration)

  button.animate({ top: "#{top}px", left: "#{left}px" }, hermitage.animationDuration)
  

# Initialize gallery on page load
$(document).ready(hermitage.init)
$(document).on('page:load', hermitage.init)