class Cpanet::PlaceViewType
  Desc = {
    :text => {},
    :link => {
      :class => {:method => :text_field, :default => "external-link btn btn-warning btn-xl btn_text_always_on_screen"},
      :type => {:method => :text_field, :default => "button"},
      :remote => {:method => :select, :select_options => ['true', 'false']},
      :hide_link_with_js => {:method => :select, :select_options => ['true', 'false']},
      :set_no_follow_tag => {:method => :select, :select_options => ['true', 'false']},
      :set_target => {:method => :select, :select_options => ['true', 'false']},
      :target_name => {:method => :text_field},
    },
    :html => {},
  }
  
  def self.program_item_view(context, program_item_to_show)
    case program_item_to_show.program.try(:place_view_type).try(:to_sym)
    when :text
      program_item_to_show.source
    when :link
      link(context, program_item_to_show.content_name, program_item_to_show.source, program_item_to_show.program.place_view_params)
    when :html
      if program_item_to_show.is_for_yandex_rsy == 'yes'
        generate_yandex_js(program_item_to_show).try(:html_safe)
      else
        program_item_to_show.source.try(:html_safe) 
      end
    else
      nil
    end
      
  end
  
  def self.generate_yandex_js(program_item_to_show)
    
    device_sizes = {:small => 400, :middle => 800, :big => 1000}
    rtb_ids = {:small => program_item_to_show.rtb_id_small, :middle => program_item_to_show.rtb_id_middle, :big => program_item_to_show.rtb_id_big}
    div_id = (rtb_ids.values.compact - [''])[0]
    return '' if div_id.blank?
    div_id = "yandex_rtb_#{div_id}"
    
    yandex_adaptive_class = program_item_to_show.use_yandex_adaptive_css_class ? 'yandex-adaptive' : ''
    
    stat_id = (Cpanet::PageType::Desc[program_item_to_show.program.try(:page).try(:to_sym)].try(:[], :page_type_stat_id) || 0).to_i * 10000 +
              (program_item_to_show.program.try(:stat_id) || 0).to_i * 100 +
              (program_item_to_show.stat_id || 0).to_i
              
    
    result = %Q{
      <div id='#{div_id}' class='#{yandex_adaptive_class} yandex-adaptive_center'></div>
      <script type='text/javascript'>

          (function(w, d, n, s, t) {
              var body_width = document.getElementsByTagName('body')[0].offsetWidth;
              var rtbBlockID = ''
              
              if ( body_width >= #{device_sizes[:big]} )\{ rtbBlockID = '#{rtb_ids[:big]}'; \}
                        
              if ( body_width <= #{device_sizes[:big]} && body_width >= #{device_sizes[:middle]} )\{rtbBlockID = '#{rtb_ids[:big]}'; \}
    
              if ( body_width <= #{device_sizes[:middle]} && body_width >= #{device_sizes[:small]} )\{rtbBlockID = '#{rtb_ids[:middle]}'; \}
              
              if ( body_width <= #{device_sizes[:small]} )\{rtbBlockID = '#{rtb_ids[:small]}'; \}
                
              w[n] = w[n] || [];
              w[n].push(function() {
                  Ya.Context.AdvManager.render({
                      blockId: rtbBlockID,
                      renderTo: '#{div_id}',
                      horizontalAlign: false,
                      statId: #{stat_id},
                      async: true
                  });
              });
              t = d.getElementsByTagName('script')[0];
              s = d.createElement('script');
              s.type = 'text/javascript';
              s.src = '//an.yandex.ru/system/context.js';
              s.async = true;
              t.parentNode.insertBefore(s, t);
          })(this, this.document, 'yandexContextAsyncCallbacks');
      </script>
      
    }

    
  end
  
  def self.link(context, link_name, link_url, original_link_params)
    link_params = original_link_params.symbolize_keys
    
    params = link_params.slice(:class, :type)
    if link_params[:hide_link_with_js] == 'true'
      url = "#"
      params.merge!({"data-link" => link_url})
    else
      url = link_url
    end
    
    link_params[:remote] == 'true' ? params.merge!({:remote => true}) : params.merge!({:remote => false})

    params.merge!({"rel" => "nofollow"}) if link_params[:set_no_follow_tag] == 'true'

    params.merge!({:onclick => context.set_target(link_params[:target_name])}) if link_params[:set_target] == 'true' and !link_params[:target_name].blank?
      
    context.link_to(link_name, url, params)
  end

end
