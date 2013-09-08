root = exports ? this

#
# Data
#

# Hermitage options
root.hermitage =
  looped: true

  # Image viewer z-index property
  default:
    styles:
      zIndex: 10
      position: 'fixed'
      top: 0
      left: 0
      width: '100%'
      height: '100%'

  # Darkening properties
  darkening:
    default:
      attributes:
        id: 'overlay'
      styles:
        position: 'absolute'
        top: 0
        left: 0
        width: '100%'
        height: '100%'
        backgroundColor: '#000'
        
    opacity: 0.85 # 0 if you don't want darkening
    styles: {}

  # Navigation buttons' properties
  navigationButtons:
    default:
      styles:
        position: 'absolute'
        width: '50px'
        height: '100%'
        top: 0
        cursor: 'pointer'
        color: '#FAFAFA'
        fontSize: '30px'
        fontFamily: 'Tahoma,Arial,Helvetica,sans-serif'
        textAlign: 'center'
        verticalAlign: 'middle'
        
    enabled: true
    styles: {}

    next:
      default:
        attributes:
          id: 'navigation-right'
        styles:
          right: 0
      styles: {}

    previous:
      default:
        attributes:
          id: 'navigation-left'
        styles:
          left: 0
      styles: {}

  # Close button properties
  closeButton:
    default:
      attributes:
        id: 'close-button'
      styles:
        position: 'absolute'
        top: 0
        right: 0
        
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
  
  # Minimum size of scaled image, px
  minimumSize:
    width: 100
    height: 100

  # Duration of all animations, ms
  animationDuration: 400

  # Array of images of current gallery
  images: []


  resizeTimeout: 100
  resizeTimer: undefined

  # Initializes the gallery on this page
  init: ->
    # Create Hermitage layer if it doesn't exist
    if $('#hermitage').length is 0
      $('<div>')
        .attr('id', 'hermitage')
        .css(hermitage.default.styles)
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

    # Set event on window resize
    $(window).resize ->
      clearTimeout(hermitage.resizeTimer) if hermitage.resizeTimer
      hermitage.resizeTimer = setTimeout \
        -> adjustImage(true),
        hermitage.resizeTimeout

#
# Helpers
#

# Place element at the center of screen
$.fn.center = (withAnimation = false, width = 0, height = 0) ->
  this.css('position', 'absolute')

  width = $(this).outerWidth() if width is 0
  height = $(this).outerWidth() if height is 0

  param =
    top: "#{Math.max(0, ($(window).height() - height) / 2)}px"
    left: "#{Math.max(0, ($(window).width() - width) / 2)}px"

  if withAnimation
    this.animate(param, { duration: hermitage.animationDuration, queue: false })
  else
    this.css(param)

$.fn.setSize = (width, height, withAnimation = false) ->
  params = { width: width, height: height}

  if withAnimation
    this.animate(params, { duration: hermitage.animationDuration, queue: false })
  else
    this.css(params)

$.fn.maximizeLineHeight = (withAnimation = false) ->
  param = { lineHeight: "#{this.outerHeight()}px" }
  
  if withAnimation
    this.animate(param, { duration: hermitage.animationDuration, queue: false })
  else
    this.css(param)

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
    .appendTo($('#hermitage'))
    .hide()
    .css(hermitage.navigationButtons.default.styles)
    .maximizeLineHeight()
    .css(hermitage.navigationButtons.styles)

# Creates right navigation button and returns it
createRightNavigationButton = ->
  createNavigationButton()
    .attr(hermitage.navigationButtons.next.default.attributes)
    .css(hermitage.navigationButtons.next.default.styles)
    .css(hermitage.navigationButtons.next.styles)
    .text('▶')
    .click(showNextImage)

# Create left navigation button and returns it
createLeftNavigationButton = ->
  createNavigationButton()
    .attr(hermitage.navigationButtons.previous.default.attributes)
    .css(hermitage.navigationButtons.previous.default.styles)
    .css(hermitage.navigationButtons.previous.styles)
    .text('◀')
    .click(showPreviousImage)

# Creates close button
createCloseButton = ->
  $('<div>')
    .appendTo($('#hermitage'))
    .hide()
    .attr(hermitage.closeButton.default.attributes)
    .css(hermitage.closeButton.default.styles)
    .text(hermitage.closeButton.text)
    .css(hermitage.closeButton.styles)
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

  showImage(indexOfImage(image))
  
# Shows image with specified index from images array
showImage = (index) ->
  # Create full size image
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

  adjustImage(false, img)

# Shows next image
showNextImage = ->
  current = $('img.current')
  if current.length is 1
    index = indexOfImage(current)
    return unless canShowNextAfter(index)
    hideCurrentImage()
    if index < hermitage.images.length - 1
      showImage(index + 1)
    else
      showImage(0)

# Shows previous image
showPreviousImage = ->
  current = $('img.current')
  if current.length is 1
    index = indexOfImage(current)
    return unless canShowPreviousBefore(index)
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


# Moves image to correct position and sets correct size.
# Then it calls adjusting methods for navigation and close buttons.
# Attributes:
# * `withAnimation` - boolean value determines if adjusting should be animated
# * `image` - currently opened image. It is optional argument and can be evaluated by the method itself.
adjustImage = (withAnimation = false, image = undefined) ->

  if image is undefined
    image = $('#hermitage img.current')
    return unless image.length is 1

  # Wait until source image is loaded
  $('<img />').attr('src', hermitage.images[indexOfImage(image)]).load ->
    
    maxWidth = $(window).width() - $('#navigation-left').outerWidth() - $('#navigation-right').outerWidth()
    maxHeight = $(window).height()

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

    image
      .setSize(this.width * scale, this.height * scale, withAnimation)
      .center(withAnimation, this.width * scale, this.height * scale)
      image.fadeIn(hermitage.animationDuration)

    adjustNavigationButtons(withAnimation, image)
    adjustCloseButton(withAnimation, image)

# Moves navigation buttons to proper positions
adjustNavigationButtons = (withAnimation, current) ->
  return unless hermitage.navigationButtons.enabled

  previous = $('#hermitage #navigation-left')
  next = $('#hermitage #navigation-right')

  # Set correct styles
  previous.maximizeLineHeight(withAnimation)
  next.maximizeLineHeight(withAnimation)
  
  # Show or hide buttons

  currentIndex = indexOfImage(current)
  
  duration = hermitage.animationDuration
  
  if canShowPreviousBefore(currentIndex)
    previous.fadeIn(duration)
  else
    previous.fadeOut(duration)

  if canShowNextAfter(currentIndex)
    next.fadeIn(duration)
  else
    next.fadeOut(duration)

# Moves close button to proper position
adjustCloseButton = (withAnimation, current) ->
  return unless hermitage.closeButton.enabled
  button = $('#hermitage #close-button')
  if button.css('display') is 'none'
    button.fadeIn(hermitage.animationDuration)

indexOfImage = (image) ->
  href = if $(image).prop('tagName') is 'IMG' then $(image).attr('src') else $(image).attr('href')
  hermitage.images.indexOf(href)

canShowNextAfter = (index) ->
  if index < hermitage.images.length - 1
    true
  else
    hermitage.looped

canShowPreviousBefore = (index) ->
  if index > 0
    true
  else
    hermitage.looped

# Initialize gallery on page load
$(document).ready(hermitage.init)
$(document).on('page:load', hermitage.init)