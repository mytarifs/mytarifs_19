module ApplicationHelper::CustomerUsedServicesCheck

  def is_user_calculating_now
    false
  end

  def is_result_run_calculating_now(result_run_id)
    false
  end

  def redirect_to_make_payment_invitation_page_if_no_free_trials_left        
    if fobidden_to_visit_customer_with_no_free_trials(controller_name) and !customer_has_free_trials?(controller_name)
      trial_message = case controller_name
      when 'calls'
          "моделирования звонков"
      when 'history_parsers'
        "загрузки звонков"
      else
        "подбора тарифа"
      end
      redirect_to(root_with_region_and_privacy(m_privacy, m_region), alert: "У вас нет доступных попыток #{trial_message}. Можете перевести деньги для получения новых")
    end      
  end
  
  def customer_has_free_trials?(controller_name_1 = controller_name)
    return true
    case 
    when controller_name_1 == 'calls'
      customer_has_free_calls_modelling_trials?
    when controller_name_1 == 'history_parsers'
      customer_has_free_history_parsing_trials?
    else
      false
    end
  end

  def customer_has_free_calls_modelling_trials?
    return true
    return false if !current_or_guest_user
    (customer_info_services_used and customer_info_services_used['calls_modelling_count'] < 1 ) ? false : true
  end
  
  def customer_has_free_history_parsing_trials?
    return true
    return false if !current_or_guest_user
    (customer_info_services_used and customer_info_services_used['calls_parsing_count'] < 1 ) ? false : true
  end
  
  def customer_has_free_tarif_optimization_trials?
    return true
    return false if !current_or_guest_user
    (customer_info_services_used and customer_info_services_used['tarif_optimization_count'] < 1 ) ? false : true
  end
  
  def customer_has_free_tarif_recalculation_trials?
    return true
    return false if !current_or_guest_user
    (customer_info_services_used and (customer_info_services_used['tarif_recalculation_count'] || 0) < 1 ) ? false : true
  end
  
  def customer_has_calls_loaded?
    return false if !current_or_guest_user
    (customer_info_services_used and customer_info_services_used['has_calls_loaded'] == true ) ? true : false
  end
  
  def customer_has_tarif_optimized?
    return false if !current_or_guest_user
#    raise(StandardError)
    (customer_info_services_used and customer_info_services_used['has_tarif_optimized'] == true ) ? true : false
  end
  
  def customer_paid_trials?
    return false if !current_or_guest_user
    (customer_info_services_used and customer_info_services_used['paid_trials'] == true ) ? true : false
  end
      
  protected
  
  def customer_info_services_used
#    @customer_info_services_used ||= 
    Customer::Info::ServicesUsed.info(current_or_guest_user.id)
  end
  
  def fobidden_to_visit_customer_with_no_free_trials(controller_name_1 = controller_name)
    ['calls', 'history_parsers'].include?(controller_name_1)
  end

end
