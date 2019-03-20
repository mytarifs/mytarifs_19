module Result::HistoryParsersHelper
  def check_uploaded_call_history_file(call_history_file)
    result = {:file_is_good => true, 'message' => nil}

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
  
  def parsing_params
    parsing_params_filtr_session_filtr_params = Customer::Info::CallsParsingParams.default_values(user_type)
    
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
  
end
