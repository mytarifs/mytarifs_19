getUrlMain = (string) ->
  string.slice(0, string.indexOf('?'))

getUrlVars = (string1) ->
  string = string1.replace(/%5B/g,'[').replace(/%5D/g,']')
  vars = {}  
  hashes = string.slice(string.indexOf('?') + 1).split('&')
  $.each hashes, (i, v)->
      hash = hashes[i].split('=')
      vars[hash[0]] = hash[1]
  vars


$(document).on 'click', '[class*=pagination1] a', ->
  a = $(this).attr('href')
  unless $.isEmptyObject(a) or a == "#"
    b = getUrlMain(a)
    c = getUrlVars(a)

    $.ajax
      url: b
      cache: true,
      data: c,
      dataType: "script"        
  false         
