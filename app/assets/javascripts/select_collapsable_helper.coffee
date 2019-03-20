$(document).on 'click', ".select-collapsable", (e) ->
  select_id = $(this).attr("for")
  select = $("[id='#{select_id}']")
  
  if $.isEmptyObject($(this).attr('select-size'))
  	select_size = 1
  else
    select_size = $(this).attr("select-size")
  
  $(this).attr('select-size', $(select).attr('size') )
  $(select).attr('size', select_size)
