module Result::OptimizatorHelper
  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::SessionInitializers
  
  def final_check_before_optimization
    result_run_to_check = result_run
    return [false, "Не выбрана детализация для расчета", :no_calls] if result_run_to_check.call_run_id.blank?
    return [false, "Не выбран период для расчета", :no_accounting_period] if result_run_to_check.accounting_period.blank?
    if !accounting_periods(result_run.call_run_id).map(&:accounting_period).include?(result_run.accounting_period)
      result_run.update(:accounting_period => nil) 
      return [false, "Выбран неправильный период для расчета", :no_accounting_period]
    end
    if_all_optimization_options_in_place    
  end
  
  def if_all_optimization_options_in_place
    case result_run.optimization_type_id
    when 0
      [true, ' ОК']
    when 1
      session_filtr_params_fixed_services_select = session_filtr_params(fixed_services_select)
      operator_id = session_filtr_params_fixed_services_select["operator_id"]
      tarif_to_calculate = session_filtr_params_fixed_services_select["tarif_to_calculate"]
      result = (!operator_id.blank? and !tarif_to_calculate.blank?)
      [result, "Не выбран тариф или оператор", :not_all_optimization_options]
    when 2
      [(!options[:selected_service_categories].blank?), 
        "Нужно выбрать хоть одну категорию #{session_filtr_params(global_categories_select)}", :not_all_optimization_options]
      
    when 3
      [options[:services_by_operator][:operators].size > 0, "Нужно выбрать хоть одного оператора", :not_all_optimization_options]
    else
      [true, "ОК"]
    end   
  end
  
  def tarif_calculation_progress_bar
    services = services_by_operator
    options = {
      'action_on_update_progress' => result_detailed_calculations_calculation_status_path(hash_with_region_and_privacy({:id => params[:id]})),
      'min_value' => 0.0,
      'max_value' => services[:tarifs].slice(*services[:operators]).values.flatten.size.to_f,
      'current_value' => Result::ServiceSet.where(:run_id => result_run.id).count.to_f
    }
    create_progress_barable('call_history_parsing', options)
  end

  def operators_select
    create_filtrable("operators_select")
  end
  
  def fixed_services_select
    create_filtrable("fixed_services_select")
  end

  def global_categories_select
    create_filtrable("global_categories_select")
  end
  

  def options
    {
      :optimization_params => optimization_params,
      :calculation_choices => calculation_choices,
      :selected_service_categories => selected_service_categories,
      :services_by_operator => services_by_operator,
      :temp_value => {
        :user_id => current_or_guest_user_id,
        :user_region_id => nil,         
        :privacy_id => m_privacy_id,
        :region_txt => m_region,
      }
    }
  end
  
  def optimization_params
    how_calculate_optimization_options = case result_run.optimization_type_id
    when 1 then { "calculate_on_background" => 'false'}
    else {"calculate_on_background" => 'true' }      
    end
    
    Customer::Info::TarifOptimizationParams.default_values.merge({
      'max_tarif_set_count_per_tarif' => 1,
      'calculate_background_with_spawnling' => 'false',
      'max_number_of_tarif_optimization_workers' => 3,
      'clean_cache' => 'false',
      'calculate_with_sidekiq' => 'true',
      'calculate_performance' => 'false',      
      'calculate_with_cache_for_operator' => 'false',      
    }).merge(how_calculate_optimization_options)
  end
  
  def selected_service_categories
    result_run.optimization_type_id == 2 ? session_filtr_params(global_categories_select) : []
  end
  
  def operators_from_operators_select
    session_filtr_params_operators_select = session_filtr_params(operators_select)
    result = []    
      {'tel' => 1023, 'bln' => 1025, 'mgf' => 1028, 'mts' => 1030}.each do |operator_name, operator_id|
        result << operator_id if session_filtr_params_operators_select[operator_name] ==  "true"
    end
    result 
  end
 
  def services_by_operator
    default_services = Customer::Info::ServiceChoices.services_from_session_to_optimization_format(Customer::Info::ServiceChoices.
      default_values(user_type, m_privacy_id, m_region))
    case result_run.optimization_type_id      
    when 1
      fixed_services_select_session_filtr_params = session_filtr_params(fixed_services_select)
      
      operator_id = fixed_services_select_session_filtr_params['operator_id'].try(:to_i)
      {
        :operators => [operator_id], 
        :tarifs => {operator_id => [fixed_services_select_session_filtr_params['tarif_to_calculate'].try(:to_i)]}, 
        :tarif_options => {operator_id => fixed_services_select_session_filtr_params['tarif_options_to_calculate'].map(&:to_i) - [0]}, 
        :common_services => {operator_id => Customer::Info::ServiceChoices.common_services(m_privacy_id, m_region)[operator_id]},
       }
    when  3 
      default_services.merge({:operators => operators_from_operators_select})
    else
      default_services
    end
  end
  
  def update_result_run_on_calculation(options)
    result_run.update({
      :optimization_params => options[:optimization_params],
      :calculation_choices => options[:calculation_choices],
      :selected_service_categories => options[:selected_service_categories],
      :services_by_operator => options[:services_by_operator],
      :temp_value => options[:temp_value],
    })
  end
  
  def calculation_choices
    case result_run.optimization_type_id
    when 1
      {
        "calculate_only_chosen_services" => true,
        "calculate_with_fixed_services" => true,        
      }
    else
      {
        "calculate_only_chosen_services" => false,
        "calculate_with_fixed_services" => false,        
      }
    end.merge({
      "accounting_period" => result_run.accounting_period,
      "call_run_id" => result_run.call_run_id,
      "result_run_id" => result_run.id,
    })        
  end
    
end
