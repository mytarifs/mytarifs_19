$(document).on 'change', "[type=checkbox]", ->
  element_id = $(this).attr("id")
  label = $("label[for=\"#{element_id}\"]")
  on_class = $(label).attr('button_on_class')
  off_class = $(label).attr('button_off_class')

  if $.isEmptyObject($(this).attr('checked'))
    $(this).attr('checked', true)
    $(label).addClass(on_class)      
    $(label).removeClass(off_class)      
  else
    $(this).attr('checked', false)
    $(label).addClass(off_class)      
    $(label).removeClass(on_class)      
