$(document).on 'ready turbolinks:load ajaxComplete', ->
  $(".external-link").each (index, lnk) ->
    $(lnk).attr("href", $(lnk).attr("data-link"))  