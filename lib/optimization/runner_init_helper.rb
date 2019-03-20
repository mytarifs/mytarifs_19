module Optimization
  module RunnerInitHelper
    def reload_general_cache(options)
      init_general_preloaded_data_for_optimization
      options[:services_by_operator][:operators].each do |operator_id|
        init_general_preloaded_data_by_operator(operator_id)
        options[:services_by_operator][:tarifs][operator_id].each do |tarif_id|
          init_preloaded_data_by_tarif(operator_id, tarif_id)   
          init_general_preloaded_data_by_operator_and_tarif(operator_id, tarif_id) 
        end
      end
    end
    
    def clean_cache(options)
      ['general_preloaded_data_for_optimization_#{privacy_id}_#{region_txt}'].each {|key| Rails.cache.delete(key)}
      options[:services_by_operator][:operators].each{|operator_id| Rails.cache.delete("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}")} if true
      options[:services_by_operator][:operators].each do |operator_id| 
        options[:services_by_operator][:tarifs][operator_id].each do |tarif_id|
          Rails.cache.delete("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_for_#{tarif_id}")
          Rails.cache.delete("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_and_#{tarif_id}")
        end        
      end if true
    end    

    def init_general_preloaded_data_by_operator(operator_id)
      Rails.cache.fetch("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}") do
        tarif_list_generator ||= Optimization::TarifListGenerator.new(options)
        tarif_list_generator.calculate_tarif_sets_and_slices(operator_id)  
        tarif_set_services = tarif_list_generator.all_services_by_operator[operator_id]
        
        calculate_general_preloaded_data_for_optimization_for_operator(tarif_set_services)
      end if !Rails.cache.exist?("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}")
    end
 
    def init_general_preloaded_data_by_operator_and_tarif(operator_id, tarif_id)
      Rails.cache.fetch("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_and_#{tarif_id}") do
        options1 = options.deep_dup
        options1[:services_by_operator][:operators] = [operator_id]
        options1[:services_by_operator][:tarifs] = {operator_id => [tarif_id]}

        tarif_list_generator ||= Optimization::TarifListGenerator.new(options1)
        tarif_list_generator.calculate_tarif_sets_and_slices(operator_id, tarif_id)  
        tarif_set_services = tarif_list_generator.all_services_by_operator[operator_id]
        
        calculate_general_preloaded_data_for_optimization_for_operator(tarif_set_services)
      end if !Rails.cache.exist?("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_and_#{tarif_id}")
    end
  
    def init_specific_calculation_inputs_for_operator(operator_id, global_categories, result_run_id)            
      Rails.cache.fetch("specific_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_for_#{result_run_id}") do
        puts "runner_init_helper: request from background for specific_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_for_#{result_run_id}"
        general_preloaded_data_for_operator = Rails.cache.fetch("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}")
        
        calculate_specific_preloaded_data_for_optimization_for_operator(general_preloaded_data_for_operator, global_categories)
      end if !Rails.cache.exist?("specific_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_for_#{result_run_id}")
    end
  
    def init_preloaded_data_by_tarif(operator_id, tarif_id)
      Rails.cache.fetch("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_for_#{tarif_id}") do
        options1 = options.deep_dup
        options1[:services_by_operator][:operators] = [operator_id]
        options1[:services_by_operator][:tarifs] = {operator_id => [tarif_id]}

        tarif_list_generator ||= Optimization::TarifListGenerator.new(options1)
        tarif_list_generator.calculate_tarif_sets_and_slices(operator_id, tarif_id) 
        calculate_general_preloaded_data_for_optimization_for_tarif(operator_id, tarif_id, tarif_list_generator) 
      end if !Rails.cache.exist?("general_preloaded_data_for_optimization_for_#{privacy_id}_#{region_txt}_#{operator_id}_for_#{tarif_id}")
    end

    def init_general_preloaded_data_for_optimization
      Rails.cache.fetch("general_preloaded_data_for_optimization_#{privacy_id}_#{region_txt}") do
        calculate_general_preloaded_data_for_optimization
      end if !Rails.cache.exist?("general_preloaded_data_for_optimization_#{privacy_id}_#{region_txt}")
    end
    
  end  
end
