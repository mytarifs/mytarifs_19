module Calls::HistoryParser  
  class Runner
    attr_reader :user_params, :parsing_params
    
    def initialize(user_params, parsing_params)
      @user_params = user_params
      @parsing_params = parsing_params
    end
  
    #Calls::HistoryParser::Runner.test
    def self.test
      user_params = {
  #      :user_id => 1,
  #      :call_run_id => 0,
  
        :operator_id => 1025
      }
      local_call_history_file = File.open('/Users/ayakushev/tarif/tmp/beeline.xls')
      file_processer = Calls::HistoryParser::FileProcessor::Xls.new(local_call_history_file)
      operator_processer = Calls::HistoryParser::ClassLoader.operator_processer(local_call_history_file, user_params[:operator_id]).new(user_params)
      call_detail_rows = file_processer.table_rows(operator_processer.table_filtrs)
    end

    def recalculate_on_back_ground(parser, call_history_file, save_calls = true)
      parser, message = Calls::HistoryParser::Parser.find_operator_parser(call_history_file, user_params, parsing_params)
      return message if !message[:file_is_good]
      
      prepare_background_process_informer
      Spawnling.new(:argv => "parsing call history file for #{user_params[:user_id]}") do
        background_process_informer.init(0, 100)
        message = parse_file(parser, call_history_file, save_calls)
        background_process_informer.finish
        message
      end    
      message 
    end
    
    def recalculate_direct(parser, call_history_file, save_calls = true)
      parse_file(parser, call_history_file, save_calls)
    end
  
    def parse_file(parser, file, save_calls = true)
      file.rewind if file.eof?
      message = parser.parse
  
      message = {:file_is_good => true, 'message' => "Обработано #{parser.processed_percent}%"} if !message
      call_history_to_save = parser.parse_result.merge({'message' => message})
      call_history_saver.save({:result => call_history_to_save}) if parsing_params[:save_processes_result_to_stat]
  
      Customer::Call.where(:user_id => user_params[:user_id], :call_run_id => user_params[:call_run_id]).delete_all
      if save_calls
        Customer::Call.bulk_insert(values: call_history_to_save['processed']) 
        
        call_run = Customer::CallRun.where(:id => user_params[:call_run_id]).first_or_create
        region_txt = user_params[:region_txt] || 'moskva_i_oblast'
        privacy_id = user_params[:privacy_id] || 2
        init_params = (call_run.init_params || {}).deep_merge({'general' => {
          'region_txt' => region_txt,
          'privacy_id' => privacy_id,
        }})
        call_run.update(:source => 1, :init_params => init_params)
        call_run.calculate_call_stat
      end
        
      call_history_to_save['message']
    end

    def parse_file_for_phone_number(parser, call_history_file, if_update_call_run_and_info = true)
      call_history_file.rewind if call_history_file.eof?
      
      detailes_from_parsing = parser.parse_for_phone_number
      
      if detailes_from_parsing[:own_number] and detailes_from_parsing[:own_number] != 'undefined'
        if if_update_call_run_and_info
          general_info = Customer::Info.where(:user_id => user_params[:user_id], :info_type_id => 1).first_or_create
          info_to_update = (general_info.info || {}).deep_merge({"call_run" => {
            user_params[:call_run_id].try(:to_s) => {
              "own_number" => detailes_from_parsing[:own_number],
              "operator_id" => detailes_from_parsing[:operator_id].try(:to_i),
              "operator_name" => detailes_from_parsing[:operator_name],
              }
            }
          })
          general_info.update(:info => info_to_update)
          
          call_run = Customer::CallRun.where(:id => user_params[:call_run_id]).first_or_create
          call_run.update(:source => 1, :operator_id => detailes_from_parsing[:operator_id].try(:to_i))
        end
        message = {:file_is_good => true, :own_number => true, 'message' => "Телефонный номер из детализации #{detailes_from_parsing[:own_number]}, оператор #{detailes_from_parsing[:operator_name]}"}
      else
        message = {:file_is_good => true, :own_number => false, 'message' => "Телефонный номер из детализации не определен, оператор #{detailes_from_parsing[:operator_name]}"}
      end
    end
    
    def find_operator_parser(call_history_file)
      parser, message = Calls::HistoryParser::Parser.find_operator_parser(call_history_file, user_params, parsing_params)
    end
        
    def call_history_saver
      Customer::Stat::OptimizationResult.new('call_history', 'call_history', user_params[:user_id])
    end
    
    def prepare_background_process_informer
      background_process_informer.clear_completed_process_info_model
      background_process_informer.init(0, 100)
    end
    
    def background_process_informer
      Customer::BackgroundStat::Informer.new('parsing_uploaded_file', user_params[:user_id])
    end
    
  end

end
