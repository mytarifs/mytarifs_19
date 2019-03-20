module Optimizator
  class Runner
    include RunnerGeneralHelper, LoadHelper
    attr_reader :options, :privacy_id, :region_txt
    
    def initialize(options = {})
      @privacy_id = options[:temp_value].try(:[], 'privacy_id') || options[:temp_value].try(:[], :privacy_id) || Category::Privacies['personal']['id']
      @region_txt = options[:temp_value].try(:[], 'region_txt') || options[:temp_value].try(:[], :region_txt) || 'moskva_i_oblast'
      raise(StandardError, [@privacy_id, @region_txt, options[:temp_value] ].to_s) if false
      @options = prepare_options(options) 
    end
    
    # res, t = Optimization::Runner.new.calculate
    def calculate           
      Customer::Stat::OptimizationResult.new('optimization_results', 'minor_results', options[:user_input][:user_id]).clean_output_results  
      clean_results(options[:user_input][:result_run_id], options[:tarif_ids_to_clean]) if options[:if_clean_output_results]  
      calculate_all
    end
    
    def calculate_all
      result = nil
      
      number_of_workers_to_add = 0

      options[:services_by_operator][:operators].each do |operator_id|        
        number_of_workers_to_add += 1
        
        if_update_call_stat = true #(options[:services_by_operator][:operators][0] == operator_id ? true : false)
        
        options1 = options.deep_dup
        options1[:services_by_operator][:operators] = [operator_id]

        run_calculation_of_one_operator(options1, if_update_call_stat)
      end
#      start_background_workers(options, number_of_workers_to_add) if ["true", true].include?(options[:optimization_params][:calculate_on_background])
      
      result
    end

    def run_calculation_of_one_operator(options, if_update_call_stat)
      background =  ["true", true].include?(options[:optimization_params][:calculate_on_background])
      sidekiq = ["true", true].include?(options[:optimization_params][:calculate_with_sidekiq])

      if background            
        ::SideTarifOptimizator.perform_async(options, if_update_call_stat)
      else
        result = calculate_one_operator(options, if_update_call_stat)
      end      
    end

    def calculate_one_operator(options, if_update_call_stat)
      my_deep_symbolize!(options)
      
      calls_to_calculate_existing_parts = Customer::Call.base_customer_call_sql(options[:user_input][:call_run_id], options[:user_input][:accounting_period])
      parts_from_calls = ::Optimizator::Global::Stat.new(options).parts_from_calls(calls_to_calculate_existing_parts)
      parts_from_options = options[:user_input][:selected_service_categories].keys.map(&:to_s)
      parts_to_use = parts_from_calls & parts_from_options
      
      tarif_list_generator = ::Optimizator::TarifListGenerator.new(options.merge({:parts_to_use => parts_to_use}))
      tarif_list_generator.tarif_pathes

      calculate_one_operator_function_name = options[:optimization_params][:calculate_one_operator_function_name]
      
      calculate_performance = ["true", true].include?(options[:optimization_params][:calculate_performance])      
      
      @performance_checker = Customer::Stat::NewOptimizatorPerformanceChecker.new() if calculate_performance      

      optimizator = ::Optimizator::Optimizator.new(options, tarif_list_generator, @performance_checker) 
      
      Customer::Stat::NewOptimizatorPerformanceChecker.apply(optimizator) if calculate_performance
         
      result = optimizator.send(calculate_one_operator_function_name, if_update_call_stat)

      update_minor_results(@performance_checker) if calculate_performance  

      result    
    end

    def clean_performance_stat_before_calculate_all(user_id)
      Customer::Stat::OptimizationResult.new('optimization_results', 'minor_results', user_id).clean_output_results  
    end
    
  end  
end
