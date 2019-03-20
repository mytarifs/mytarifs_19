module ApplicationHelper::Seo

  def set_target(target_name)
    "ga('push', ['_trackPageview','/virtual/#{target_name}_ga/']); yaCounter33344083.reachGoal('#{target_name}_met'); return true;".html_safe
  end
   
end
