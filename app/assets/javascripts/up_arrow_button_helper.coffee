$(document).on 'ready', ->
  offset = 400
  duration = 300
  $(window).on 'scroll', -> 
    if ($(this).scrollTop() > offset)
      $(".back-to-top").fadeIn(duration)
    else
      $(".back-to-top").fadeOut(duration)

  $(".back-to-top").on 'click', (event) ->
     event.preventDefault()
     $('html, body').animate({scrollTop: 0}, duration)
     return false
