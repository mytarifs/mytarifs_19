$(document).on 'ready turbolinks:load ajaxComplete', ->
  $("[data-toggle=popover]").popover()
