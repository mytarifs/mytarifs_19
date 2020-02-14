class Customer::HistoryParsersController < ApplicationController
  include Customer::HistoryParsersHelper, Customer::HistoryParsersBackgroundHelper
  helper Customer::HistoryParsersHelper, Customer::HistoryParsersBackgroundHelper
#  include Crudable
#  crudable_actions :index

  before_action :create_call_run_if_not_exists, only: [:prepare_for_upload]
  before_action :check_if_parsing_params_in_session, only: [:parse, :prepare_for_upload]
  before_action :call_history_saver_clean_output_results, only: [:parse, :upload]
  before_action :init_background_process_informer, only: [:upload, :calculation_status, :parse]
  after_action :track_upload, only: :upload
  after_action :track_prepare_for_upload, only: :prepare_for_upload

  helper_method :customer_history_parser
  
  add_breadcrumb "Загрузка детализации", -> context {context.customer_history_parsers_prepare_for_upload_path(context.hash_with_context_region_and_privacy(context)) }

  def prepare_for_upload
    customer_call_run = Customer::CallRun.where(:id => session_filtr_params(call_run_choice)["customer_call_run_id"]).first
    add_breadcrumb "Сохраненные загрузки или моделирования звонков: #{customer_call_run.try(:name)}", customer_call_runs_path(hash_with_region_and_privacy)
    add_breadcrumb "Загрузка детализаций звонков, задание параметров"#,  customer_history_parsers_prepare_for_upload_path
  end
  
  def calculation_status
    add_breadcrumb "Анализ детализации"#, :customer_history_parsers_calculation_status_path
    
    if !background_process_informer.calculating?   
      if Customer::Call.where(:call_run_id => customer_call_run_id).present?
        redirect_user_to_registration_or_main_tarif_optimization
      else
        redirect_to(hash_with_region_and_privacy({:action => :prepare_for_upload}), {:notice => "Не загрузился ни один звонок. Выберите другую детализацию или сообщите нам"})
      end
    end
  end
  
  def parse
    local_call_history_file = File.open('tmp/megafon_small.html') 
    update_customer_infos

    history_parser_runner = Calls::HistoryParser::Runner.new(user_params, parsing_params)
    parser, message = history_parser_runner.find_operator_parser(params[:call_history])
    redirect_to( hash_with_region_and_privacy({:action => :prepare_for_upload}), {:alert => message}) and return if !message[:file_is_good]

    message = history_parser_runner.recalculate_direct(parser, call_history_file, false) 
    redirect_to( hash_with_region_and_privacy({:action => :prepare_for_upload}), {:notice => message})
  end

  def upload
    message = params[:call_history] ? check_uploaded_call_history_file(params[:call_history]) : {:file_is_good => false, 'message' => "Вы не выбрали файл для загрузки"}
    if message[:file_is_good] == true       
      update_customer_infos

      history_parser_runner = Calls::HistoryParser::Runner.new(user_params, parsing_params)
      parser, message = history_parser_runner.find_operator_parser(params[:call_history])
      redirect_to( hash_with_region_and_privacy({:action => :prepare_for_upload}), {:alert => message}) and return if !message[:file_is_good]
      
      message = history_parser_runner.parse_file_for_phone_number(parser, params[:call_history])
  
      if parsing_params[:calculate_on_background]
        message = history_parser_runner.recalculate_on_back_ground(parser, params[:call_history], true)
        if message[:file_is_good]
          redirect_to hash_with_region_and_privacy({:action => :calculation_status}) 
        else
          redirect_to( hash_with_region_and_privacy({:action => :prepare_for_upload}), {:notice => message})
        end
      else      
        message = history_parser_runner.recalculate_direct(parser, params[:call_history], true) 
        redirect_to( hash_with_region_and_privacy({:action => :prepare_for_upload}), {:notice => message})
      end
    else
      text_message = (message.is_a?(Hash) and !message.blank?) ? message['message'] : message
      redirect_to( hash_with_region_and_privacy({:action => :prepare_for_upload}), {:alert => text_message})  
    end    
  end 
    
  private
  
end
