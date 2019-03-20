$(document).on 'change', "[type=radio]", ->
  pressed_radio = this
  radio_name = $(this).attr("name")

  $("[name^=\"#{radio_name}\"]").each (index, element) ->
    element_id = $(element).attr("id")
    label = $("label[for=\"#{element_id}\"]")
    on_class = $(label).attr('button_on_class')
    off_class = $(label).attr('button_off_class')
    if $(pressed_radio).attr("value") == $(element).attr("value")
      $(element).attr('checked', true)
      $(label).addClass(on_class)      
      $(label).removeClass(off_class)      
    else
      $(element).attr('checked', false)      
      $(label).addClass(off_class)      
      $(label).removeClass(on_class)      
  