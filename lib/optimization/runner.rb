module Optimization
  class Runner
    include RunnerInitHelper, RunnerGeneralHelper, LoadHelper
    attr_reader :options, :privacy_id, :region_txt
    
    def initialize(options = {})
      @privacy_id = options[:temp_value].try(:[], 'privacy_id') || options[:temp_value].try(:[], :privacy_id) || Category::Privacies['personal']['id']
      @region_txt = options[:temp_value].try(:[], 'region_txt') || options[:temp_value].try(:[], :region_txt) || 'moskva_i_oblast'
      @options = prepare_options(options) 
    end
    
    # res, t = Optimization::Runner.new.calculate
    def calculate           
      start = Time.now
      
      if ["true", true].include?(options[:optimization_params][:calculate_with_cache_for_operator]) #options[:optimization_params][:calculate_with_cache_for_operator]        
        clean_cache(options) if ["true", true].include?(options[:optimization_params][:clean_cache])
        options[:services_by_operator][:operators].each{|operator_id| Rails.cache.
            delete("specific_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_for_#{options[:user_input][:result_run_id]}")}
      end

      Customer::Stat::OptimizationResult.new('optimization_results', 'minor_results', options[:user_input][:user_id]).clean_output_results  
      clean_results(options[:user_input][:result_run_id]) if options[:if_clean_output_results]  
      calculate_all
#      [self, Time.now - start]        
    end
    
    def clean_performance_stat_before_calculate_all(user_id)
      Customer::Stat::OptimizationResult.new('optimization_results', 'minor_results', user_id).clean_output_results  
    end

    def calculate_all
      result = nil
      
      init_general_preloaded_data_for_optimization

      number_of_workers_to_add = 0
      
      options[:services_by_operator][:operators].each do |operator_id|        
        if ["true", true].include?(options[:optimization_params][:calculate_with_cache_for_operator])          
          init_general_preloaded_data_by_operator(operator_id)
          init_specific_calculation_inputs_for_operator(operator_id, options[:user_input][:selected_service_categories], options[:user_input][:result_run_id])
        end

        options[:services_by_operator][:tarifs][operator_id].each do |tarif_id|
          init_preloaded_data_by_tarif(operator_id, tarif_id) if ["true", true].include?(options[:optimization_params][:calculate_with_cache_for_operator])
          number_of_workers_to_add += 1
          
          run_calculation_of_one_tarif(operator_id, tarif_id)
        end
      end
      start_background_workers(options, number_of_workers_to_add) if ["true", true].include?(options[:optimization_params][:calculate_on_background])
      
      result
    end
    
    def run_calculation_of_one_tarif(operator_id, tarif_id)
      background =  ["true", true].include?(options[:optimization_params][:calculate_on_background])
      sidekiq = ["true", true].include?(options[:optimization_params][:calculate_with_sidekiq])

      options1 = options.deep_dup
      options1[:services_by_operator][:operators] = [operator_id]
      options1[:services_by_operator][:tarifs] = {operator_id => [tarif_id]}
      
      if_update_call_stat = (options[:services_by_operator][:tarifs][operator_id][0] == tarif_id ? true : false)

      if background            
        if sidekiq
          ::SideTarifOptimization.perform_async(options1, operator_id, tarif_id, if_update_call_stat)
        else                            
          Delayed::Job.enqueue Background::Job::Optimization.new(options1, false, nil, nil, nil, operator_id, tarif_id, if_update_call_stat), 
            :priority => 100, :reference_id => options1[:user_input][:result_run_id], :reference_type => 'result_run'
        end
      else
        result = calculate_one_tarif(options1, operator_id, tarif_id, if_update_call_stat)
      end      
    end

    def calculate_one_tarif(options, operator_id, tarif_id, if_update_call_stat)
      my_deep_symbolize!(options)
      calculate_one_tarif_function_name = options[:optimization_params][:calculate_one_tarif_function_name]
      
      calculate_performance = ["true", true].include?(options[:optimization_params][:calculate_performance])      
      
      @performance_checker = Customer::Stat::NewOptimizationPerformanceChecker.new() if calculate_performance      

      optimizator = Optimization::Optimizator.new(options, @performance_checker) 
      
      Customer::Stat::NewOptimizationPerformanceChecker.apply(optimizator) if calculate_performance
         
      result = optimizator.send(calculate_one_tarif_function_name, operator_id, tarif_id, if_update_call_stat)

      update_minor_results(@performance_checker) if calculate_performance  

      result    
    end
    
  end  
end
