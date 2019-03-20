module ApplicationHelper::DefaultRenderer
#  extend ActiveSupport::Concern
  def default_render(options = nil)    
#    raise(StandardError, [controller_name, action_name, params])
    
    respond_to do |format|
      format.html
      format.js {render_js(view_context.default_view_id_name)}
      format.json
      format.any_format {render }
    end
  end

  def render_js(id_of_page_to_substitute, template = action_name)
    view_context.tap do |v|
#      js_string = v.content_tag(:div, render_to_string(:action => template, :layout => 'layouts/_ajax_load_block.html.erb'), {:id => v.view_id_name})
#      js_string = "$('##{id_of_page_to_substitute}').html(\" #{v.escape_javascript js_string} \");"          
#      render action_name
      js_string = v.content_tag(:div, render_to_string(:action => template, :layout => 'layouts/_ajax_load_block.html.erb'), {:id => id_of_page_to_substitute,  :class => "col-xs-12"})
      js_string = "$('##{id_of_page_to_substitute}').replaceWith(\" #{v.escape_javascript js_string} \");"          
      render :inline => js_string#, :content_type => 'text/html'#, :layout => 'application'
    end
  end
  
end
