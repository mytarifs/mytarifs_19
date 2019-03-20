module TarifOptimizators::AdminHelper
  include TarifOptimizators::SharedHelper
  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::SessionInitializers, SavableInSession::ProgressBarable

  def optimization_params
    create_filtrable("optimization_params")
  end
  
  def service_choices
    create_filtrable("service_choices")
  end
  
  def services_select
    create_filtrable("services_select")
  end
  
  def services_for_calculation_select
    create_filtrable("services_for_calculation_select")
  end

  def show_services_for_calculation_select_tab
    session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true' ? true : false
  end

  def update_customer_infos
    update_result_run_on_calculation(options)
    Customer::Info::ServicesSelect.update_info(current_or_guest_user_id, session_filtr_params(services_select)) if user_type == :admin
    Customer::Info::ServiceChoices.update_info(current_or_guest_user_id, session_filtr_params(service_choices)) if user_type == :admin
    Customer::Info::TarifOptimizationParams.update_info(current_or_guest_user_id, session_filtr_params(optimization_params)) if user_type == :admin

    Customer::Info::CalculationChoices.update_info(current_or_guest_user_id, session_filtr_params(calculation_choices))

    if session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true'
      Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'tarif_recalculation_count')
    else
      Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'tarif_optimization_count')      
    end
  end
  
  def m_privacy_id
    if use_local_m_region_and_m_privacy
      session_filtr_params(calculation_choices).try(:[], 'privacy_id').try(:to_i) || 2
    else
      super
    end        
  end

  def options
    session_filtr_params_services_select = user_type == :admin ? session_filtr_params(services_select) : Customer::Info::ServicesSelect.default_values(user_type) #just in case for future
    {
      :optimization_params => session_filtr_params_optimization_params,
#      :service_choices => session_filtr_params(service_choices),
      :calculation_choices => session_filtr_params(calculation_choices),
      :selected_service_categories => nil,
      :services_by_operator => services_by_operator,
      :temp_value => {
        :user_id => current_or_guest_user_id,
        :user_region_id => nil,         
        :user_priority => user_priority,      
        :privacy_id => m_privacy_id,
        :region_txt => m_region,
      }
    }
  end
  
#  def operator
#    optimization_params_session_filtr_params = session_filtr_params(optimization_params)
#    optimization_params_session_filtr_params['operator_id'].blank? ? 1030 : optimization_params_session_filtr_params['operator_id'].to_i
#  end
  
  def session_filtr_params_optimization_params
    user_type == :admin ? session_filtr_params(optimization_params) : Customer::Info::TarifOptimizationParams.default_values
  end

  def services_by_operator
    session_filtr_params(calculation_choices)['calculate_with_fixed_services'] == 'true' ? services_by_operator_for_calculate_with_fixed_services :  
      services_by_operator_for_calculate_with_all_services
  end
  
  def services_by_operator_for_calculate_with_fixed_services
    services_for_calculation_select_session_filtr_params = session_filtr_params(services_for_calculation_select)
    operator_id = services_for_calculation_select_session_filtr_params['operator_id'].to_i
    {
      :operators => [operator_id], 
      :tarifs => {operator_id => [services_for_calculation_select_session_filtr_params['tarif_to_calculate'].to_i]}, 
      :tarif_options => {operator_id => services_for_calculation_select_session_filtr_params['tarif_options_to_calculate'].map(&:to_i) - [0]}, 
      :common_services => {operator_id => Customer::Info::ServiceChoices.common_services(m_privacy_id, m_region)[operator_id]},
     }
  end
  
  def services_by_operator_for_calculate_with_all_services
    service_choices_session_filtr_params = user_type == :admin ? session_filtr_params(service_choices) : 
      Customer::Info::ServiceChoices.default_values(user_type, m_privacy_id, m_region)
    Customer::Info::ServiceChoices.services_from_session_to_optimization_format(service_choices_session_filtr_params, m_privacy_id, m_region)
  end

  def validate_tarifs
    params['service_choices_filtr'].merge!(Customer::Info::ServiceChoices.
      validate_tarifs(params['service_choices_filtr'], m_privacy_id, m_region)) if params['service_choices_filtr']
  end
  
  def check_if_optimization_options_are_in_session
    if session[:filtr]['service_choices_filtr'].blank? and user_type == :admin
      session[:filtr]['service_choices_filtr'] ||= {}
      session[:filtr]['service_choices_filtr']  = Customer::Info::ServiceChoices.info(current_or_guest_user_id)
    end

    if session[:filtr]['services_select_filtr'].blank? and user_type == :admin
      session[:filtr]['services_select_filtr'] ||= {}
      session[:filtr]['services_select_filtr']  = Customer::Info::ServicesSelect.info(current_or_guest_user_id)
    end
    
    if session[:filtr]['optimization_params_filtr'].blank? and user_type == :admin
      session[:filtr]['optimization_params_filtr'] ||= {}
      session[:filtr]['optimization_params_filtr']  = Customer::Info::TarifOptimizationParams.info(current_or_guest_user_id)
    end
    
    if session[:filtr]['calculation_choices_filtr'].blank?
      session[:filtr]['calculation_choices_filtr'] ||= {}
      session[:filtr]['calculation_choices_filtr']  = Customer::Info::CalculationChoices.info(current_or_guest_user_id).
        merge({'call_run_id' => customer_call_run_id, 'accounting_period' => accounting_period})
    end

  end

  def tarif_calculation_progress_bar
    services = services_by_operator
    options = {
      'action_on_update_progress' => tarif_optimizators_admin_calculation_status_path(hash_with_region_and_privacy),
      'min_value' => 0.0,
      'max_value' => services[:tarifs].slice(*services[:operators]).values.flatten.size.to_f,
      'current_value' => Result::ServiceSet.where(:run_id => result_run_id).count.to_f
    }
    create_progress_barable('call_history_parsing', options)
  end
  
end
