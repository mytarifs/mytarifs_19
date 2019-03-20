module Optimization
  class Optimizator
    include LoadHelper
    attr_reader :options
    attr_reader :tarif_results, :stat_after_calculations, :final_tarif_sets, :stat, :privacy_id, :region_txt
    
    def initialize(options = {}, performance_checker = nil)
      my_deep_symbolize!(options)

      raise(StandardError, [options[:services_by_operator][:tarifs]]) if false and options[:services_by_operator][:tarifs][1028].blank?
      @options = options
      @tarif_results = {}; @stat_after_calculations = {}; @final_tarif_sets = {}; @stat = {}
      @privacy_id = options[:user_input][:privacy_id]
      @region_txt = options[:user_input][:region_txt]
      @performance_checker = performance_checker
    end
    
    def calculate_tarif_cost_by_tarif(operator_id, tarif_id, if_update_call_stat = false)#, calls, global_stat)
      preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif = init_preloaded_data(operator_id, tarif_id, options[:user_input][:result_run_id])      

      tarif_cost_calculator = init_tarif_cost_calculator(preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif)

      update_call_stat(options[:user_input][:result_run_id], operator_id) if true and if_update_call_stat    
      
      temp_tarif_results, temp_stat_after_calculations, temp_stat = calculate_tarifs_results_by_tarif(preloaded_data_by_tarif, tarif_cost_calculator, tarif_id)
      
      raise(StandardError, [
        temp_tarif_results
      ]) if false
      
      temp_final_tarif_sets = calculate_final_tarif_sets(preloaded_data_by_tarif, tarif_cost_calculator, tarif_id, temp_tarif_results)
  
      service_sets_array, services_array, categories_array, agregates_array = calculate_detailed_final_tarif_results(
        operator_id, tarif_id, preloaded_data, preloaded_data_by_tarif, temp_final_tarif_sets, tarif_cost_calculator)

      save_final_tarif_results(operator_id, tarif_id, service_sets_array, services_array, categories_array, agregates_array)
    end
    
    def calculate_only_tarif_results_by_tarif(operator_id, tarif_id, if_update_call_stat = false)
      preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif = init_preloaded_data(operator_id, tarif_id, options[:user_input][:result_run_id])      

      tarif_cost_calculator = init_tarif_cost_calculator(preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif)

      selected_service_categories_parts = options[:user_input][:selected_service_categories].keys.map(&:to_s)
      
      parts_without_fixed = selected_service_categories_parts - ['periodic', 'onetime']
      
      temp_tarif_results, temp_stat_after_calculations, temp_stat = tarif_cost_calculator.
        calculate_tarifs_cost_by_tarif(preloaded_data_by_tarif['tarif_sets'].slice(*parts_without_fixed), false) 

      save_tarif_results_without_fixed(tarif_id, temp_tarif_results)
    end
    
    def calculate_only_fixed_single_tarif_results_by_tarif(operator_id, tarif_id, if_update_call_stat = false)
      preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif = init_preloaded_data(operator_id, tarif_id, options[:user_input][:result_run_id])      

      tarif_cost_calculator = init_tarif_cost_calculator(preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif)

      temp_tarif_results, temp_stat_after_calculations, temp_stat = tarif_cost_calculator.
        calculate_tarifs_cost_by_tarif(preloaded_data_by_tarif['tarif_sets'].slice('periodic', 'onetime'), false) 

      save_fixed_tarif_results(tarif_id, temp_tarif_results)
    end
    
    def calculate_final_tarif_sets_by_tarif_from_prepared_tarif_results(operator_id, tarif_id, if_update_call_stat = false)
      preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif = init_preloaded_data(operator_id, tarif_id, options[:user_input][:result_run_id])      

      tarif_cost_calculator = init_tarif_cost_calculator(preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif)

      temp_tarif_results = load_temp_tarif_results_from_saved_tarif_results(options[:user_input][:temp_result_run_ids], tarif_id)
      raise(StandardError, [
        
      ]) if false and tarif_id == 8632
      temp_final_tarif_sets = calculate_final_tarif_sets(preloaded_data_by_tarif, tarif_cost_calculator, tarif_id, temp_tarif_results)

      service_sets_array, services_array, categories_array, agregates_array, 
        tarif_set_to_recalculate_1, temp_tarif_results_1, temp_stat_1 = calculate_detailed_final_tarif_results(
        operator_id, tarif_id, preloaded_data, preloaded_data_by_tarif, temp_final_tarif_sets, tarif_cost_calculator)

      row = service_sets_array[0]
      
      save_final_tarif_results(operator_id, tarif_id, service_sets_array, services_array, categories_array, agregates_array)
      
      [ service_sets_array[0].try(:[], 'price')].join("\n")
    end
    
    def load_temp_tarif_results_from_saved_tarif_results(result_run_ids, tarif_id)
      temp_tarif_results = {}
      Result::TarifResult.where(:run_id => result_run_ids, :tarif_id => tarif_id).pluck(:result).each do |result|
        raise(StandardError, [
          temp_tarif_results.keys,
          result.keys
        ]) if result.keys.size != (result.keys - temp_tarif_results.keys).size
        temp_tarif_results.merge!(result)
      end
      temp_tarif_results
    end
    
    def init_preloaded_data(operator_id, tarif_id, result_run_id)
      preloaded_data = init_general_preloaded_data_for_optimization(operator_id, tarif_id)
      general_preloaded_data_for_operator = init_general_preloaded_data_for_optimization_for_operator(operator_id, tarif_id)
      specific_preloaded_data_by_operator = init_specific_preloaded_data_for_optimization_for_operator(operator_id, tarif_id, result_run_id, general_preloaded_data_for_operator)
      preloaded_data_by_tarif = init_general_preloaded_data_for_optimization_for_tarif(operator_id, tarif_id)
      [preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif]
    end
    
    def init_general_preloaded_data_for_optimization(operator_id, tarif_id)
      Rails.cache.fetch("general_preloaded_data_for_optimization_#{privacy_id}_#{region_txt}") do
        puts "request from background for general_preloaded_data_for_optimization_#{privacy_id}_#{region_txt}"
        calculate_general_preloaded_data_for_optimization
      end
    end
    
    def init_general_preloaded_data_for_optimization_for_operator(operator_id, tarif_id)
      if ["true", true].include?(options[:optimization_params][:calculate_with_cache_for_operator])
        Rails.cache.fetch("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}") do
          puts "request from background for general_preloaded_data_for_#{privacy_id}_#{region_txt}_optimization_for_#{operator_id}"
          tarif_list_generator ||= Optimization::TarifListGenerator.new(options)
          tarif_list_generator.calculate_tarif_sets_and_slices(operator_id)
          tarif_set_services = tarif_list_generator.all_services_by_operator[operator_id]
          calculate_general_preloaded_data_for_optimization_for_operator(tarif_set_services)
        end
      else
        Rails.cache.fetch("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_and_#{tarif_id}") do
          puts "request from background for general_preloaded_data_for_#{privacy_id}_#{region_txt}_optimization_for_#{operator_id} and #{tarif_id}"
          tarif_list_generator ||= Optimization::TarifListGenerator.new(options)
          tarif_list_generator.calculate_tarif_sets_and_slices(operator_id, tarif_id)
          tarif_set_services = tarif_list_generator.all_services_by_operator[operator_id]
          calculate_general_preloaded_data_for_optimization_for_operator(tarif_set_services)
        end
      end
    end
    
    def init_specific_preloaded_data_for_optimization_for_operator(operator_id, tarif_id, result_run_id, general_preloaded_data_for_operator)
      if ["true", true].include?(options[:optimization_params][:calculate_with_cache_for_operator])
        Rails.cache.fetch("specific_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_for_#{result_run_id}") do
          puts "request from background for specific_preloaded_data_for_#{privacy_id}_#{region_txt}_optimization_for_#{operator_id}_for_#{result_run_id} #{tarif_id}"
          calculate_specific_preloaded_data_for_optimization_for_operator(general_preloaded_data_for_operator, options[:user_input][:selected_service_categories])
        end
      else
        calculate_specific_preloaded_data_for_optimization_for_operator(general_preloaded_data_for_operator, options[:user_input][:selected_service_categories])
      end
    end

    def init_general_preloaded_data_for_optimization_for_tarif(operator_id, tarif_id)
      if ["true", true].include?(options[:optimization_params][:calculate_with_cache_for_operator])
        Rails.cache.fetch("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_for_#{tarif_id}") do
          puts "request from background for general_preloaded_data_for_#{privacy_id}_#{region_txt}_optimization_for_#{operator_id}_for_#{tarif_id}"
          tarif_list_generator ||= Optimization::TarifListGenerator.new(options)
          tarif_list_generator.calculate_tarif_sets_and_slices(operator_id, tarif_id)  
          calculate_general_preloaded_data_for_optimization_for_tarif(operator_id, tarif_id, tarif_list_generator)
        end
      else
        tarif_list_generator ||= Optimization::TarifListGenerator.new(options)
        tarif_list_generator.calculate_tarif_sets_and_slices(operator_id, tarif_id)  
        calculate_general_preloaded_data_for_optimization_for_tarif(operator_id, tarif_id, tarif_list_generator)
      end
    end

    def init_tarif_cost_calculator(preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif)
      tarif_cost_calculator = Optimization::TarifsCostCalculator.new
      tarif_cost_calculator.init_tarif_cost_calculator(preloaded_data, general_preloaded_data_for_operator, specific_preloaded_data_by_operator, preloaded_data_by_tarif)
      tarif_cost_calculator
    end
    
    def calculate_tarifs_results_by_tarif(preloaded_data_by_tarif, tarif_cost_calculator, tarif_id)
      selected_parts_with_fixed = options[:user_input][:selected_service_categories].keys.map(&:to_s) + ['periodic', 'onetime'] 
      if [true, 'true'].include?(options[:tarif_list_generator_params][:calculate_with_fixed_services])
        tarif_list_generator ||= Optimization::TarifListGenerator.new(options)
        operator_id = options[:services_by_operator][:operators][0]
        tarif_list_generator.calculate_tarif_sets_and_slices(operator_id)  
        tarif_set_services = tarif_list_generator.tarif_sets[tarif_id]
        temp_tarif_results = tarif_cost_calculator.calculate_tarifs_cost_by_tarif(tarif_set_services, false)
        final_tarif_results = {}
        tarif_set_services.each do |part, tarif_set_by_part|     
          next if tarif_set_by_part.blank?
          
          correct_tarif_set_name = tarif_set_by_part.keys.sort_by!{|key| -key.split("_").size}[0]
          
          tarif_set_by_part.each do |tarif_set_name, services|
            next if tarif_set_name != correct_tarif_set_name
            
            if !temp_tarif_results[0][part].blank?
              final_tarif_results[part] ||= {}              
              final_tarif_results[part][tarif_set_name] = temp_tarif_results[0][part][correct_tarif_set_name] 
            end
          end
        end
        raise(StandardError, [
          tarif_set_services, "#############", final_tarif_results
        ]) if false
        
        final_tarif_results
      else
        tarif_cost_calculator.calculate_tarifs_cost_by_tarif(preloaded_data_by_tarif['tarif_sets'].slice(*selected_parts_with_fixed), false)
      end      
    end
    
    def calculate_final_tarif_sets(preloaded_data_by_tarif, tarif_cost_calculator, tarif_id, temp_tarif_results)
      tarif_sets_to_use = if [true, 'true'].include?(options[:tarif_list_generator_params][:calculate_with_fixed_services])
        tarif_list_generator ||= Optimization::TarifListGenerator.new(options)
        operator_id = options[:services_by_operator][:operators][0]
        tarif_list_generator.calculate_tarif_sets_and_slices(operator_id)  
        tarif_list_generator.tarif_sets[tarif_id]
      else
        preloaded_data_by_tarif['tarif_sets']
      end

      result = Optimization::FinalTarifSetGenerator.new({}, @performance_checker).calculate_final_tarif_sets(tarif_cost_calculator, tarif_id, temp_tarif_results, 
          preloaded_data_by_tarif['service_packs_by_parts'], tarif_sets_to_use, preloaded_data_by_tarif['allowed_common_services'],
          preloaded_data_by_tarif['services_that_depended_on'])
      result              
    end
    
    def calculate_detailed_final_tarif_results(operator_id, tarif_id, preloaded_data, preloaded_data_by_tarif, temp_final_tarif_sets, tarif_cost_calculator)
      service_sets_array = []; services_array = []; categories_array = []; agregates_array = [];
      
      tarif_set_to_recalculate = {}; temp_tarif_results = {}; temp_stat = {}
      
      temp_final_tarif_sets.each do |final_tarif_set_name, final_tarif_set_by_part|
        tarif_set_to_recalculate = {}
        final_tarif_set_by_part.each do |part, tarif_result_by_part|
          tarif_set_to_recalculate[part] ||= {}
          tarif_result_by_part.keys.each do |tarif_set_by_part_name|
            tarif_set_to_recalculate[part][tarif_set_by_part_name] = preloaded_data_by_tarif["tarif_sets"][part][tarif_set_by_part_name]
          end
        end
  
        temp_tarif_results = {}; temp_stat_after_calculations = {}; temp_stat = {}
        
        temp_tarif_results[final_tarif_set_name], temp_stat_after_calculations[final_tarif_set_name], temp_stat[final_tarif_set_name] = tarif_cost_calculator.
          calculate_tarifs_cost_by_tarif(tarif_set_to_recalculate, true)
          
        new_service_sets_array, new_services_array, new_categories_array, new_agregates_array = Optimization::FinalTarifResultPreparator.new.prepare_service_sets(
          operator_id, tarif_id, options[:user_input][:result_run_id], final_tarif_set_name, temp_stat[final_tarif_set_name], preloaded_data)
    
        service_sets_array += new_service_sets_array; services_array += new_services_array; categories_array += new_categories_array; agregates_array += new_agregates_array
      end    
      [service_sets_array, services_array, categories_array, agregates_array, 
        tarif_set_to_recalculate, temp_tarif_results, temp_stat]
    end
    
    def save_final_tarif_results(operator_id, tarif_id, service_sets_array, services_array, categories_array, agregates_array)
      raise(StandardError, service_sets_array)
      Optimization::FinalTarifResultPreparator.new.save(operator_id, tarif_id, options[:user_input][:result_run_id], service_sets_array, services_array, categories_array, agregates_array)
    end
  
    def save_tarif_results_without_fixed(tarif_id, temp_tarif_results)
      run_id = options[:user_input][:result_run_id]      
      part = (temp_tarif_results.keys - ["onetime", "periodic"]).first
      raise(StandardError) if (temp_tarif_results.keys - ["onetime", "periodic"]).size > 1
      tarif_results_to_save = temp_tarif_results.slice(part)
      tarif_result = Result::TarifResult.find_or_create_by(:run_id => run_id, :tarif_id => tarif_id, :part => part)
      tarif_result.update!(:result => tarif_results_to_save)
    end
  
    def save_fixed_tarif_results(tarif_id, temp_tarif_results)
      run_id = options[:user_input][:result_run_id]      
      ["onetime", "periodic"].each do |part|
        tarif_results_to_save = temp_tarif_results.slice(part)
        tarif_result = Result::TarifResult.find_or_create_by(:run_id => run_id, :tarif_id => tarif_id, :part => part)
        tarif_result.update!(:result => tarif_results_to_save)
      end
    end
  
    def update_call_stat(result_run_id, operator_id)
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
