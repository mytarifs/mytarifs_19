module Optimization
  module RunnerGeneralHelper
  
    def start_background_workers(options, number_of_workers_to_add)
      sidekiq = ["true", true].include?(options[:optimization_params][:calculate_with_sidekiq])
      worker_name = sidekiq ? "worker" : "tarif_optimization"
      
      begin
        base_worker_add_number = (options[:optimization_params].try(:[], :max_number_of_tarif_optimization_workers) || 1).to_i
        base_worker_add_number = options[:user_input][:user_id] == 1 ? base_worker_add_number : 1
        number_of_workers_to_add = [
          base_worker_add_number - Background::WorkerManager::Manager.worker_quantity(worker_name),
          number_of_workers_to_add
        ].min
        puts ["Background::WorkerManager::Manager.start_number_of_worker", worker_name, number_of_workers_to_add].to_s
        Background::WorkerManager::Manager.start_number_of_worker(worker_name, number_of_workers_to_add)
      rescue => e
        raise(StandardError, e)
      end        
    end
 
    def clean_results(run_id)
      if run_id
        Result::Tarif.where(:run_id => run_id).delete_all
        Result::ServiceSet.where(:run_id => run_id).delete_all
        Result::Service.where(:run_id => run_id).delete_all
        Result::Agregate.where(:run_id => run_id).delete_all
        Result::ServiceCategory.where(:run_id => run_id).delete_all
      end
    end
    module_function :clean_results

    def update_minor_results(performance_checker)
      minor_result_saver = Customer::Stat::OptimizationResult.new('optimization_results', 'minor_results', options[:user_input][:user_id])
      start_time = minor_result_saver.results['start_time'].to_datetime if minor_result_saver.results and minor_result_saver.results['start_time']
      start_time = performance_checker.start if performance_checker and !start_time
      
      saved_performance_results = minor_result_saver.results['original_performance_results'] if minor_result_saver.results
      updated_original_performance_results = performance_checker.add_current_results_to_saved_results(saved_performance_results, start_time) if performance_checker
      minor_result_saver.save({:result => 
        {:performance_results => (performance_checker ? performance_checker.show_stat_hash(updated_original_performance_results) : {}),
         :original_performance_results => updated_original_performance_results,
         :start_time => start_time,
         }})
    end

    def prepare_options(options = {})
      optimization_params = options[:optimization_params] || {}
      calculation_choices = options[:calculation_choices] || {}
      excluded_service_category_parts = ['all-world-rouming/calls', 'all-world-rouming/sms', 'all-world-rouming/mms', 'all-world-rouming/mobile-connection']
      selected_service_categories = !options[:selected_service_categories].blank? ? options[:selected_service_categories] :
        Optimization::Global::Base.new(options).global_names_by_parts(Optimization::Global::Base::StructureByParts.keys - excluded_service_category_parts)#['own_and_home_regions/internet', 'own_and_home_regions/calls_out/to_own_and_home_regions/to_operators']#, 'own_and_home_regions/sms_in', ]
      services_by_operator = options[:services_by_operator] || default_services
      temp_value = options[:temp_value] || {}
      raise(StandardError, [options ]) if false
      {
       :optimization_params => {
          :max_number_of_tarif_optimization_workers => (optimization_params['max_number_of_tarif_optimization_workers'].try(:to_i) || 1),
          :calculate_with_cache_for_operator => (!optimization_params['calculate_with_cache_for_operator'].nil? ? 
            optimization_params['calculate_with_cache_for_operator'] : false), 
          :clean_cache => (!optimization_params['clean_cache'].nil? ? optimization_params['clean_cache'] : false), 
          :calculate_on_background => (!optimization_params['calculate_on_background'].nil? ? optimization_params['calculate_on_background'] : true),
          :calculate_with_sidekiq => (!optimization_params['calculate_with_sidekiq'].nil? ? optimization_params['calculate_with_sidekiq'] : true),
          :calculate_performance => (!optimization_params['calculate_performance'].nil? ? optimization_params['calculate_performance'] : false),
          :calculate_one_tarif_function_name => optimization_params['calculate_one_tarif_function_name'] || 'calculate_tarif_cost_by_tarif',
         },
       :user_input => {
          :accounting_period => calculation_choices['accounting_period'] || '1_2015',
          :call_run_id => calculation_choices['call_run_id'] || 85,#553,
#          :calculate_with_limited_scope => calculation_choices['calculate_with_limited_scope'],
          :selected_service_categories => selected_service_categories,
          :result_run_id => calculation_choices['result_run_id'] || "1142",#563,
          :temp_result_run_ids => calculation_choices['temp_result_run_ids'] || [], #to use in FastOptimization::DataLoader
          :user_id => temp_value[:user_id] || 1,
          :user_region_id => temp_value[:user_region_id] || Category::Region::Const::Moskva,             
          :region_txt => region_txt || 'moskva_i_oblast',             
          :privacy_id => privacy_id || Category::Privacies['personal']['id'],             
         },
       :services_by_operator => services_by_operator,
       :final_tarif_set_generator_params => {
          :max_tarif_set_count_per_tarif => optimization_params['max_tarif_set_count_per_tarif'] || 1,
         },
       :tarif_list_generator_params => {
          :calculate_with_multiple_use => (!optimization_params['calculate_with_multiple_use'].nil? ? optimization_params['calculate_with_multiple_use'] : "true"),
          :calculate_only_chosen_services => calculation_choices['calculate_only_chosen_services'],
          :calculate_with_fixed_services => (!optimization_params['calculate_with_fixed_services'].nil? ? optimization_params['calculate_with_fixed_services'] : "false"),       
         },
       :if_clean_output_results => (!options[:if_clean_output_results].nil? ? options[:if_clean_output_results] : true), 
       :background_job_type => (!options[:background_job_type].nil? ? options[:background_job_type] : "tarif_optimization"), 
       }   
    end
    
    #Optimization::Runner.new.default_services
    def default_services
      {
        :operators => Customer::Info::ServiceChoices.operators, #[1028, 1025, 1023, 1030],#
        :tarifs => Customer::Info::ServiceChoices.tarifs(privacy_id, region_txt),#{1023 => [801], 1025 => [623], 1028 => [103], 1030 => [202]},#
        :common_services => Customer::Info::ServiceChoices.common_services(privacy_id, region_txt),#{1023 => [830, 831, 832], 1025 => [], 1028 => [], 1030 => []},#
        :tarif_options => Customer::Info::ServiceChoices.tarif_options(privacy_id, region_txt),#{1023 => [], 1025 => [], 1028 => [471], 1030 => []}#
      }
    end    
  
    def my_deep_symbolize!(hash)
      hash.deep_transform_keys! do |key| 
        begin
          Integer(key) 
        rescue 
          key.to_sym 
        rescue 
          key
        end
      end 
      hash
    end
  end  
end
