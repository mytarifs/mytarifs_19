module Customer::HistoryParsersHelper
  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::SessionInitializers

  def m_region    
    if use_local_m_region_and_m_privacy
      session_filtr_params(user_params_filtr)['region_txt'] || 'moskva_i_oblast'
    else
      super
    end        
  end
  
  def call_history_saver
    Customer::Stat::OptimizationResult.new('call_history', 'call_history', current_or_guest_user_id)
  end
  
  def call_history_saver_clean_output_results
    call_history_saver.clean_output_results
  end
  
  def call_history_results
    (call_history_saver.results || {'processed' => [{}], 'unprocessed' => [{}], 'ignorred' => [{}], 'original_doc' => [{}] } )
  end
  
  def call_history
    options = {:base_name => 'call_history', :current_id_name => 'base_service_id', :id_name => 'base_service_id', :pagination_per_page => 10}
    create_array_of_hashable(call_history_results['processed'], options)
  end
  
  def call_history_unprocessed
    options = {:base_name => 'unprocessed_call_history', :current_id_name => 'unprocessed_column', :id_name => 'unprocessed_column', :pagination_per_page => 10}
    create_array_of_hashable(call_history_results['unprocessed'], options)
  end
  
  def call_history_ignorred
    options = {:base_name => 'ignorred_call_history', :current_id_name => 'ignorred_column', :id_name => 'ignorred_column', :pagination_per_page => 10}
    create_array_of_hashable(call_history_results['ignorred'], options)
  end

  def parsing_params_filtr
    create_filtrable("parsing_params")
  end
  
  def user_params_filtr
    create_filtrable("user_params")
  end

  def update_customer_infos
    Customer::Info::CallsDetailsParams.update_info(current_or_guest_user_id, session_filtr_params(user_params_filtr))
    Customer::Info::CallsParsingParams.update_info(current_or_guest_user_id, session_filtr_params(parsing_params_filtr)) if user_type == :admin
    Customer::Info::ServicesUsed.decrease_one_free_trials_by_one(current_or_guest_user_id, 'calls_parsing_count')  
    Customer::CallRun.find(customer_call_run_id).update(:operator_id => user_params[:operator_id])  
  end
  
  def check_uploaded_call_history_file(call_history_file)
    result = {:file_is_good => true, 'message' => nil}

#    message = "Не выбран оператор. Выберите вашего оператора"
#    return result = {:file_is_good => false, 'message' => message} if user_params[:operator_id].blank? or user_params[:operator_id] == 0

    file_size = (call_history_file.size / 1000000.0).round(2) if call_history_file
#    raise(StandardError, [file_size, parsing_params[:file_upload_max_size], parsing_params["file_upload_max_size"], user_params, parsing_params])    
    message = "Файл слишком большой: #{file_size}Mb. Он должен быть не больше #{parsing_params[:file_upload_max_size]}Mb"
    return result = {:file_is_good => false, 'message' => message} if file_size > parsing_params[:file_upload_max_size]

    file_type = file_type(call_history_file)
    message = "Файл неправильного типа #{file_type}. Он должен быть один из #{parsing_params[:allowed_call_history_file_types]}"
    return result = {:file_is_good => false, 'message' => message} if !parsing_params[:allowed_call_history_file_types].include?(file_type)
    
    message = "Тип файла не совпадает с разрешенным типом файла для оператора"
    return result = {:file_is_good => false, 'message' => message} if false and (user_params[:operator_id] > 0) and !check_if_file_type_match_with_operator(file_type)
    
    result
  end
  
  def check_if_file_type_match_with_operator(file_type)
    Calls::HistoryParser::ClassLoader.check_if_file_type_match_with_operator(file_type, user_params[:operator_id])
  end
  
  def file_type(file)
    Calls::HistoryParser::ClassLoader.file_type(file)
  end
  
  def call_run_choice
    create_filtrable("call_run_choice")
  end

  def customer_call_run_id
    session[:filtr]["call_run_choice_filtr"] ||= {}
    if session[:filtr]["call_run_choice_filtr"]['customer_call_run_id'].blank?
      session[:filtr]["call_run_choice_filtr"]['customer_call_run_id'] = Customer::CallRun.where(:user_id => current_or_guest_user_id, :source => [0, 1]).
      where(:stat => nil).first_or_create(:name => "Пробная загрузка детализации", :source => 1, :description => "", :user_id => current_or_guest_user_id).id
    end
    session_filtr_params(call_run_choice)['customer_call_run_id'].to_i
  end
  
  def create_call_run_if_not_exists
    1.times.each do |i|
      Customer::CallRun.create(:name => "Загрузка детализации №#{i}", :source => 1, :description => "", :user_id => current_or_guest_user_id)
    end if !Customer::CallRun.where(:user_id => current_or_guest_user_id, :source => [0, 1]).present?
  end

  def user_params
    user_params_filtr_session_filtr_params = session_filtr_params(user_params_filtr)
    {
      :user_id => current_or_guest_user_id,
      :call_run_id => customer_call_run_id,

      :own_phone_number => (user_params_filtr_session_filtr_params['own_phone_number']),
      :operator_id => 0, #user_params_filtr_session_filtr_params['operator_id'].to_i,
      :region_id => (::Category::MobileRegions[m_region]['region_ids'][0] || ::Category::Region::Const::Moskva).to_i, 
      :region_txt => m_region,
      :privacy_id => m_privacy_id,
      :country_id => (user_params_filtr_session_filtr_params['country_id'] || 1100).to_i, 
      :accounting_period_month => (user_params_filtr_session_filtr_params['accounting_period_month']),
      :accounting_period_year => (user_params_filtr_session_filtr_params['accounting_period_year']),
    }
  end
  
  def parsing_params
    parsing_params_filtr_session_filtr_params = 
    user_type == :admin ? session_filtr_params(parsing_params_filtr) : 
    Customer::Info::CallsParsingParams.default_values(user_type)
    
    {
#      :background_process_informer => background_process_informer,
      :calculate_on_background => (parsing_params_filtr_session_filtr_params['calculate_on_background'] == 'true' ? true : false),
      :save_processes_result_to_stat => (parsing_params_filtr_session_filtr_params['save_processes_result_to_stat'] == 'true' ? true : false),
      :file_upload_remote_mode => (parsing_params_filtr_session_filtr_params['file_upload_remote_mode'] == 'true' ? true : false),
      :file_upload_turbolink_mode => (parsing_params_filtr_session_filtr_params['file_upload_turbolink_mode'] == 'true' ? true : false),
      :file_upload_max_size => parsing_params_filtr_session_filtr_params['file_upload_max_size'].to_f,
      :call_history_max_line_to_process => parsing_params_filtr_session_filtr_params['call_history_max_line_to_process'].to_f,
      :allowed_call_history_file_types => ['html', 'xls', 'xlsx', 'pdf'], #parsing_params_filtr_session_filtr_params['allowed_call_history_file_types'],
      :background_update_frequency => parsing_params_filtr_session_filtr_params['background_update_frequency'].to_i,
      :file_upload_form_method => parsing_params_filtr_session_filtr_params['file_upload_form_method'],
      :sleep_after_file_uploading => parsing_params_filtr_session_filtr_params['sleep_after_file_uploading'].to_f,
    }
  end
  
  def check_if_parsing_params_in_session
    session[:filtr] ||= {}
    if session[:filtr]['user_params_filtr'].blank?
      session[:filtr]['user_params_filtr'] ||= {}
      session[:filtr]['user_params_filtr'] = Customer::Info::CallsDetailsParams.info(current_or_guest_user_id, m_region)
    end

    if session[:filtr]['parsing_params_filtr'].blank? and user_type == :admin
      session[:filtr]['parsing_params_filtr'] ||= {}
      session[:filtr]['parsing_params_filtr'] = Customer::Info::CallsParsingParams.info(current_or_guest_user_id)
      #Customer::Info::CallsParsingParams.default_values(user_type)
    end
  end

end
