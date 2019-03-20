module Optimizator
  class Optimizator
    include LoadHelper
    attr_reader :options, :tarif_list_generator, :operator_id, :result_run_id
    attr_reader :tarif_results, :stat_after_calculations, :final_tarif_sets, :stat, :privacy_id, :region_txt
    
    def initialize(options = {}, tarif_list_generator = nil, performance_checker = nil)
      my_deep_symbolize!(options)
      @options = options
      @operator_id = options[:services_by_operator][:operators][0]
      @result_run_id = options[:user_input][:result_run_id]
      @tarif_results = {}; @stat_after_calculations = {}; @final_tarif_sets = {}; @stat = {}
      @privacy_id = options[:user_input][:privacy_id]
      @region_txt = options[:user_input][:region_txt]
      raise(StandardError, [@privacy_id, @region_txt, options[:user_input] ].to_s) if false
      @tarif_list_generator = tarif_list_generator || (tlg = ::Optimizator::TarifListGenerator.new(options); tlg.tarif_pathes; tlg;)
      @performance_checker = performance_checker
    end
    
    def calculate_tarif_cost_by_operator(if_update_call_stat = false, parts_to_calculate = nil, calculate_only_tarif_cost = false)      
      tarif_cost_calculator = ::Optimizator::TarifsCostCalculator.new(tarif_list_generator, @performance_checker)
      Customer::Stat::NewOptimizatorPerformanceChecker.apply(tarif_cost_calculator) if ["true", true].include?(options[:optimization_params][:calculate_performance])
      tarif_cost_calculator.init_tarif_cost_calculator_general(options)
      tarif_cost_calculator.init_tarif_cost_calculator_stat(options)

      (parts_to_calculate || tarif_list_generator.parts).each do |part|
        calculate_tarif_cost_by_operator_by_part(tarif_cost_calculator, part)
      end       
      
      return tarif_results if calculate_only_tarif_cost
      
      update_call_stat if true and if_update_call_stat

      tarif_list_generator.tarifs.each do |tarif_id|
        tarif_results_for_tarif_id = {}
        tarif_list_generator.tarif_sets[tarif_id].map do |part, tarif_sets_by_part| 
          tarif_results_for_tarif_id[part] ||={}
          tarif_results_for_tarif_id[part] = tarif_results[part].slice(*tarif_sets_by_part.keys)
        end
        temp_final_tarif_sets = calculate_final_tarif_sets(tarif_cost_calculator, tarif_id, tarif_results_for_tarif_id)
    
        service_sets_array, services_array, categories_array, agregates_array = calculate_detailed_final_tarif_results(
          tarif_id, temp_final_tarif_sets, tarif_cost_calculator)
  
        save_final_tarif_results(tarif_id, service_sets_array, services_array, categories_array, agregates_array)
      end
    end
    
    def calculate_tarif_cost_by_operator_by_part(tarif_cost_calculator, part)
        tarif_cost_calculator.calculate_tarifs_cost_by_part(part, false) 
        final_tarif_set_ids = tarif_list_generator.tarif_sets.map{|tarif_id, tarif_sets_by_part| tarif_sets_by_part[part].keys }.flatten
        tarif_results[part] = tarif_cost_calculator.tarif_results[part].slice(*final_tarif_set_ids)  
    end
    
    def calculate_final_tarif_sets(tarif_cost_calculator, tarif_id, temp_tarif_results)
      tarif_sets_to_use = if [true, 'true'].include?(options[:tarif_list_generator_params][:calculate_with_fixed_services])
        tarif_list_generator.tarif_sets[tarif_id]
      else
        tarif_list_generator.tarif_sets[tarif_id]
      end
      
      final_tarif_set_generator = ::Optimizator::FinalTarifSetGenerator.new({}, @performance_checker)
      Customer::Stat::NewOptimizatorPerformanceChecker.apply(final_tarif_set_generator) if ["true", true].include?(options[:optimization_params][:calculate_performance])

      result = final_tarif_set_generator.calculate_final_tarif_sets(tarif_cost_calculator, tarif_id, temp_tarif_results, 
          tarif_list_generator.service_packs_by_parts[tarif_id], tarif_sets_to_use, tarif_list_generator.allowed_common_services[tarif_id],
          tarif_list_generator.services_that_depended_on)
      result              
    end
    
    def calculate_detailed_final_tarif_results(tarif_id, temp_final_tarif_sets, tarif_cost_calculator)
      service_sets_array = []; services_array = []; categories_array = []; agregates_array = [];
      tarif_cost_calculator.tarif_results_for_final = {}
      
      tarif_set_to_recalculate = {}; temp_tarif_results = {}; temp_stat = {}
      
      temp_final_tarif_sets.each do |final_tarif_set_name, final_tarif_set_by_part|
        tarif_set_to_recalculate = {}
        final_tarif_set_by_part.each do |part, tarif_result_by_part|
          tarif_set_to_recalculate[part] ||= {}
          tarif_result_by_part.keys.each do |tarif_set_by_part_name|
            tarif_set_to_recalculate[part][tarif_set_by_part_name] = tarif_list_generator.tarif_sets[tarif_id][part][tarif_set_by_part_name]
          end
        end
  
        temp_tarif_results = {}; temp_stat_after_calculations = {}; temp_stat = {}
        
        temp_tarif_results[final_tarif_set_name], temp_stat_after_calculations[final_tarif_set_name], temp_stat[final_tarif_set_name] = tarif_cost_calculator.
          calculate_tarifs_cost_by_tarif(tarif_set_to_recalculate, true)
          
        preloaded_data = {
          'service_categories' => tarif_cost_calculator.service_categories,
          'general_categories' => general_categories,
        }
         
        new_service_sets_array, new_services_array, new_categories_array, new_agregates_array = ::Optimizator::FinalTarifResultPreparator.new.prepare_service_sets(
          operator_id, tarif_id, options[:user_input][:result_run_id], final_tarif_set_name, temp_stat[final_tarif_set_name], preloaded_data)
    
        service_sets_array += new_service_sets_array; services_array += new_services_array; categories_array += new_categories_array; agregates_array += new_agregates_array
      end    
      [service_sets_array, services_array, categories_array, agregates_array, 
        tarif_set_to_recalculate, temp_tarif_results, temp_stat]
    end
    
    def save_final_tarif_results(tarif_id, service_sets_array, services_array, categories_array, agregates_array)
      ::Optimizator::FinalTarifResultPreparator.new.save(operator_id, tarif_id, options[:user_input][:result_run_id], service_sets_array, services_array, categories_array, agregates_array)
    end
  
    def update_call_stat
      global_category_names_by_parts = options[:user_input][:selected_service_categories]
      global_category_where_hash = Optimization::Global::Base.new(options).filtr_from_global_category_names(global_category_names_by_parts)
      
      call_run_id = options[:user_input][:call_run_id]
      accounting_period = options[:user_input][:accounting_period]
      privacy_id = options[:user_input][:privacy_id]
      region_txt = options[:user_input][:region_txt]

      calls = Customer::Call.base_customer_call_sql(call_run_id, accounting_period).where(global_category_where_hash)

      call_stat = Optimization::Global::CallStat.new(options).calculate_calls_stat(calls)
      result_call_stat_row = Result::CallStat.where(:run_id => result_run_id, :operator_id => operator_id).first_or_create
      result_call_stat_row.stat = {} if !result_call_stat_row.stat.is_a?(Hash)
      result_call_stat = result_call_stat_row.stat || {}
      result_call_stat[accounting_period] ||= {}
      result_call_stat[accounting_period][privacy_id.to_s] ||= {}
      result_call_stat[accounting_period][privacy_id.to_s][region_txt] = call_stat
            
      result_call_stat_row.update_columns(:stat => result_call_stat)    
    end







    def calculate_only_tarif_results_by_operator(if_update_call_stat = false)
      selected_service_categories_parts = options[:user_input][:selected_service_categories].keys.map(&:to_s)      
      parts_without_fixed = selected_service_categories_parts - ['periodic', 'onetime']
      
      temp_tarif_results = calculate_tarif_cost_by_operator(if_update_call_stat, parts_without_fixed, true)

      save_tarif_results_without_fixed(temp_tarif_results)
    end
    
    def calculate_only_fixed_single_tarif_results_by_operator(operator_id, if_update_call_stat = false)
      fixed_parts = ['periodic', 'onetime']
      temp_tarif_results = calculate_tarif_cost_by_operator(if_update_call_stat, fixed_parts, true)

      save_fixed_tarif_results(temp_tarif_results)
    end
    
    def calculate_final_tarif_sets_by_tarif_from_prepared_tarif_results(if_update_call_stat = false)
      tarif_cost_calculator = ::Optimizator::TarifsCostCalculator.new(tarif_list_generator, @performance_checker)
      tarif_cost_calculator.init_tarif_cost_calculator_general(options)
      tarif_cost_calculator.init_tarif_cost_calculator_stat(options)

      tarif_list_generator.tarifs.each do |tarif_id|        
        temp_tarif_results = load_temp_tarif_results_from_saved_tarif_results(options[:user_input][:temp_result_run_ids], tarif_id)
        tarif_results_for_tarif_id = {}
        tarif_list_generator.tarif_sets[tarif_id].map do |part, tarif_sets_by_part| 
          tarif_results_for_tarif_id[part] ||={}
          tarif_results_for_tarif_id[part] = temp_tarif_results[part].slice(*tarif_sets_by_part.keys)
        end
        temp_final_tarif_sets = calculate_final_tarif_sets(tarif_cost_calculator, tarif_id, tarif_results_for_tarif_id)
    
        service_sets_array, services_array, categories_array, agregates_array = calculate_detailed_final_tarif_results(
          tarif_id, temp_final_tarif_sets, tarif_cost_calculator)
  
        save_final_tarif_results(tarif_id, service_sets_array, services_array, categories_array, agregates_array)
      end
    end
    
    def load_temp_tarif_results_from_saved_tarif_results(result_run_ids, tarif_id)
      raise(StandardError) if false
      temp_tarif_results = {}
      Result::TarifResult.where(:run_id => result_run_ids, :tarif_id => tarif_id).pluck(:result).each do |result|

        temp_tarif_results.merge!(result)
      end
      temp_tarif_results
    end
    
    def save_tarif_results_without_fixed(temp_tarif_results)
      run_id = options[:user_input][:result_run_id]      
      part = (temp_tarif_results.keys - ["onetime", "periodic"]).first

      tarif_list_generator.tarifs.each do |tarif_id|
        tarif_results_for_tarif_id = {}
        tarif_sets_by_part = tarif_list_generator.tarif_sets[tarif_id][part] 

        tarif_results_for_tarif_id[part] ||={}
        tarif_results_for_tarif_id[part] = temp_tarif_results[part]

        tarif_result = Result::TarifResult.find_or_create_by(:run_id => run_id, :tarif_id => tarif_id, :part => part)
        tarif_result.update!(:result => tarif_results_for_tarif_id)
      end

    end
  
    def save_fixed_tarif_results(temp_tarif_results)
      run_id = options[:user_input][:result_run_id]      
      ["onetime", "periodic"].each do |part|
        tarif_list_generator.tarifs.each do |tarif_id|
          tarif_results_for_tarif_id = {}
          tarif_sets_by_part = tarif_list_generator.tarif_sets[tarif_id][part] 
  
          tarif_results_for_tarif_id[part] ||={}
          tarif_results_for_tarif_id[part] = tarif_results[part]
  
          tarif_result = Result::TarifResult.find_or_create_by(:run_id => run_id, :tarif_id => tarif_id, :part => part)
          tarif_result.update!(:result => tarif_results_for_tarif_id)
        end
      end
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
