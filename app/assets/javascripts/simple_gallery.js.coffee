root = exports ? this

$(document).ready ->
  init_simple_gallery()

root.init_simple_gallery = () ->  
  # Create simple gallery layout
  simpleGallery = $("<div>", {id: "simple_gallery"})
  $("body").append(simpleGallery)
  simpleGallery.css("z-index", 10)
  simpleGallery.hide()


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
    this.css("position", "absolute")
    this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) + $(window).scrollTop()) + "px")
    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) + $(window).scrollLeft()) + "px")
    this


  #
  # Simple gallery logic
  #

  # Creates overlay layer, shows it and sets its click handler
  create_overlay = () ->
    $("#simple_gallery").append($('<div id="overlay"></div>'))

    $("#overlay").css("position", "fixed")
    $("#overlay").css("top", "0")
    $("#overlay").css("left", "0")
    $("#overlay").css("background", "black")
    $("#overlay").css("display", "block")
    $("#overlay").css("opacity", "0.75")
    $("#overlay").css("filter", "alpha(opacity=75)")
    $("#overlay").css("width", "100%")
    $("#overlay").css("height", "100%")

    $("#overlay").hide()
    $("#overlay").fadeIn()

    $("#overlay").click (event) ->
      close_gallery()


  # Shows full size image of the chosen one
  open_gallery = (image) ->
    $("#simple_gallery").empty()
    $("#simple_gallery").show()
    create_overlay()

    # Create full size image at the center of screen
    img = $('<img />')
    img.attr('src', $(image).attr('href'))
    $("#simple_gallery").append(img)
    img.hide()

    # When image will be loaded set correct size,
    # center element and show it
    $("<img />").attr("src", img.attr("src")).load ->
      img.width(this.width)
      img.height(this.height)
      img.center()
      img.fadeIn()
    
  
  # Starts fade out animation and clears simple gallery at the end of animation
  close_gallery = () ->
    $("#simple_gallery :not(#overlay)").fadeOut()
    $("#overlay").fadeOut 400, ->
      $("#simple_gallery").hide()
      $("#simple_gallery").empty()