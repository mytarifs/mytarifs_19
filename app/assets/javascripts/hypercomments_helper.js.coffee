check_load_hypercomments = (progresspump) ->
  if document.getElementById('hypercomments_widget') and !(document.getElementById('hypercomments_widget').innerHTML != '')  
    document.getElementById('hypercomments_widget').innerHTML = ''
    _hcp = {}
    _hcp.widget_id = 75821
    _hcp.xid   = null 
    HC.widget("Stream", _hcp)  
  
$(document).on 'ready turbolinks:load ajaxComplete', ->
  progresspump = setTimeout -> 
    check_load_hypercomments progresspump
  , 1000

