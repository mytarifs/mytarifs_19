$(document).on 'click', "a[my_collapsable]", (e) ->
  if $(this).attr("aria-expanded") == "true"
  	$(this).children().addClass('fa-angle-up').removeClass('fa-angle-down')
  else
  	$(this).children().addClass('fa-angle-down').removeClass('fa-angle-up')

$(document).on 'click', "div.my_collapsable", (e) ->
  $(e.target).find("a[my_collapsable]").click()    	
