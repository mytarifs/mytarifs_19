module Result::CallsGeneratorHelper
  def m_region 
    if use_local_m_region_and_m_privacy
      session_filtr_params(region_txt_select)['region_txt'] || 'moskva_i_oblast'
    else
      super
    end            
  end
  
  def calls_gener_params_report
    options = {:base_name => 'call_generation_params_report', :current_id_name => 'param', :id_name => 'param', :pagination_per_page => 20}
    create_array_of_hashable(
      Calls::GenerationParamsPresenter.new(Calls::Generator.new(customer_calls_generation_params, user_params), customer_calls_generation_params).report, options )
  end
  
  def setting_default_calls_generation_params
    customer_calls_generation_params_filtr.each do |key, value|
      usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
      session[:filtr][value.filtr_name] = Calls::Generator.default_calls_generation_params(key, usage_pattern_id, m_region)[key]
    end
  end
  
  def update_usage_pattern
    unchanged_params = params.dup
    old_usage_type = {}
    ['customer_calls_generation_params_general_filtr', 'customer_calls_generation_params_own_region_filtr', 'customer_calls_generation_params_home_region_filtr', 
      'customer_calls_generation_params_own_country_filtr', 'customer_calls_generation_params_abroad_filtr'].each do |rouming_type|
        old_usage_type[rouming_type] = session[:filtr][rouming_type]['phone_usage_type_id'].to_s if session[:filtr] and session[:filtr][rouming_type]
    end

    customer_calls_generation_params_filtr.each do |key, value|
      if unchanged_params and unchanged_params[value.filtr_name] and unchanged_params[value.filtr_name]['phone_usage_type_id'] != old_usage_type[value.filtr_name]
        
        usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
        session[:filtr][value.filtr_name] = Calls::Generator.default_calls_generation_params(key, usage_pattern_id, m_region)[key]  
         if key == :general
           new_usage_types = Calls::Generator.update_all_usage_patterns_based_on_general_usage_type(unchanged_params[value.filtr_name]['phone_usage_type_id'])
           session[:filtr].merge!(new_usage_types)           
           setting_default_calls_generation_params   
         end        
      end 
    end
  end
  
  def setting_if_nil_default_calls_generation_params
    customer_calls_generation_params_filtr.each do |key, value|
      if session[:filtr][value.filtr_name].blank?
        usage_pattern_id = session[:filtr][value.filtr_name]['phone_usage_type_id']
        session[:filtr][value.filtr_name] = Calls::Generator.default_calls_generation_params(key, usage_pattern_id, m_region)[key]
      end
    end
  end
  
  def customer_calls_generation_params
    result = {}
    customer_calls_generation_params_filtr.keys.each do |key|
      result[key] = session_filtr_params(customer_calls_generation_params_filtr[key])
    end
    result[:general]["region_id"] = Category::MobileRegions[m_region]['region_ids'][0]
    result[:general]["region_txt"] = m_region
    result[:general]["privacy_id"] = m_privacy_id
    result
  end
  
  def customer_calls_generation_params_filtr
    return {
      :general => create_filtrable("customer_calls_generation_params_general"),
      :own_region => create_filtrable("customer_calls_generation_params_own_region"),
      :home_region => create_filtrable("customer_calls_generation_params_home_region"),
      :own_country => create_filtrable("customer_calls_generation_params_own_country"),
      :abroad => create_filtrable("customer_calls_generation_params_abroad"),
    }      
  end

  def customer_call_simple_form
    modeble = create_modeble(Customer::Call::SimpleForm)
    modeble.model.valid?
    modeble
  end
  
  
end
