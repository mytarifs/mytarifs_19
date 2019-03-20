module Optimizator
  class TarifsCostCalculator
    include LoadHelper, ::Optimizator::Global::StandardFormulas
    
    attr_reader :formula_params, :service_categories_for_fixed, :global_stat, :global_category_by_parts, :service_categories
    attr_reader :tarif_list_generator, :tarif_results, :stat
    attr_accessor :tarif_results_for_final
    
    def initialize(tarif_list_generator, performance_checker)
      @tarif_list_generator = tarif_list_generator
      @tarif_results = {}
      @tarif_results_for_final = {}
      @stat = {}
      @performance_checker = performance_checker
    end
    
    def calculate_tarifs_cost_by_part(part, if_save_stat = false)    
      tarif_results[part] ||= {}; stat[part] ||= {}
      initial_stat = ['periodic', 'onetime'].include?(part) ? global_stat.deep_dup : global_stat.slice(*global_category_by_parts[part]).deep_dup
      tarif_pathes = tarif_list_generator.tarif_pathes[part] || {} 
      calculate_tarif_path_keys(part, tarif_pathes, initial_stat, [], if_save_stat)
    end
    
    def calculate_tarif_path_keys(part, current_tarif_pathes, current_stat, prev_tarif_set_services, if_save_stat = false)
      tarif_set_stat = {}

      current_tarif_pathes.each_with_index do |(service_id, next_tarif_pathes), tarif_path_index|
        tarif_pathes_size = current_tarif_pathes.keys.size
        stat_to_use = (tarif_pathes_size < 2 or tarif_path_index == (tarif_pathes_size - 1)) ? current_stat.deep_dup : current_stat.deep_dup
        tarif_set_stat[:service_id] = service_id; tarif_set_stat[:prev_service_ids] = prev_tarif_set_services; 
        tarif_set_stat[:is_service_a_tarif] = tarif_list_generator.tarifs.include?(service_id);
        
        service_result, stat_params = calculate_tarif_set_service(stat_to_use, tarif_set_stat, part, if_save_stat)

        current_tarif_set = [service_id] + prev_tarif_set_services
        prev_tarif_result = prev_tarif_set_services.blank? ? 0.0 : tarif_results[part][prev_tarif_set_services.join("_")]

        tarif_results[part][current_tarif_set.join("_")] = prev_tarif_result + service_result
        
        if next_tarif_pathes.blank?
          if if_save_stat
            stat[part] ||= {}
            stat[part][current_tarif_set.join("_")] = stat_params
            #stat_to_use = nil
          end                 
        else
          calculate_tarif_path_keys(part, next_tarif_pathes, stat_to_use, current_tarif_set, if_save_stat)
          #stat_to_use = nil
        end        
      end
    end
    
    def calculate_tarifs_cost_by_tarif(tarif_set, if_save_stat = false) 
      tarif_results = {}; stat_after_calculations = {}; stat = {}   
      
      tarif_set.keys.sort.each do |part|
        next if !['periodic', 'onetime'].include?(part) and ((global_stat.keys || []) & (global_category_by_parts[part] || [])).blank?
        
        tarif_set[part].each do |tarif_set_id, services|
          tarif_results[part] ||= {}; stat_after_calculations[part] ||= {}; 

          services = tarif_set_id.split("_").map(&:to_i) if !services
          
          next if ['periodic', 'onetime'].include?(part) and services.size > 1 and !if_save_stat
                    
          tarif_results[part][tarif_set_id] ||= 0.0
          
          new_tarif_result, stat_after_calculations[part][tarif_set_id], stat_params = calculate_tarif_set(part, services, if_save_stat)
          
          tarif_results[part][tarif_set_id] += new_tarif_result
          
          if if_save_stat
            stat[part] ||= {}
            stat[part][tarif_set_id] = stat_params
          end                 
        end
      end
      [tarif_results, stat_after_calculations, stat]
    end
    
    def calculate_tarif_set(part, services, if_save_stat = false)
      tarif_results_for_final[part] ||= {}
      result = 0.0; stat = {}

      current_stat = ['periodic', 'onetime'].include?(part) ? global_stat.deep_dup : global_stat.slice(*global_category_by_parts[part]).deep_dup      
      reversed_services = services.reverse
      tarif_set_stat = {}

      reversed_services.each_with_index do |service_id, service_index|        
        prev_tarif_set_services = service_index == 0 ? [] : reversed_services[0..service_index - 1]
        current_service_set_id = (prev_tarif_set_services + [service_id]).join("_")
        
        if true and ['periodic', 'onetime'].include?(part) and service_index > 0 and tarif_results_for_final[part][current_service_set_id]
          service_result = tarif_results_for_final[part][current_service_set_id][:service_result] - (tarif_results_for_final[part][prev_tarif_set_services.join("_")][:service_result] || 0.0)
          tarif_set_stat = tarif_results_for_final[part][current_service_set_id][:tarif_set_stat]
          stat_params = tarif_results_for_final[part][current_service_set_id][:stat_params] 
        else
          tarif_set_stat[:service_id] = service_id; tarif_set_stat[:prev_service_ids] = prev_tarif_set_services;    
          tarif_set_stat[:is_service_a_tarif] = tarif_list_generator.tarifs.include?(service_id);    
          service_result, stat_params = calculate_tarif_set_service(current_stat, tarif_set_stat, part, if_save_stat)
          tarif_results_for_final[part][current_service_set_id] ||= {}       
          tarif_results_for_final[part][current_service_set_id].deep_merge!({:service_result => service_result, :tarif_set_stat => tarif_set_stat, :stat_params => (if_save_stat ? stat_params : {})})
        end
        
        stat[service_id] = stat_params if if_save_stat
        result += service_result
      end
      [result, current_stat, stat]
    end

    def calculate_tarif_set_service(current_stat, tarif_set_stat, part, if_save_stat = false)
      result = 0.0; stat = {}
      
      service_id = tarif_set_stat[:service_id]; prev_tarif_set_services = tarif_set_stat[:prev_service_ids]
      tarif_set_stat[:is_service_a_tarif] = tarif_list_generator.tarifs.include?(service_id);
      
      return [result, stat] if current_stat.blank?
      
      formula_params[part][service_id].keys.sort.each do |calculation_order|
        formula_params[part][service_id][calculation_order].each do |service_category_group_id, item|
          
          is_service_group_depended_on = !item[:service_categories_with_options].blank?
          tarif_set_stat[:current_service_group_dependent_on] = is_service_group_depended_on
          current_depended_on_services = item[:service_categories_with_options].keys.flatten.uniq & (prev_tarif_set_services + [service_id])
          
          if is_service_group_depended_on
            depended_on_services = if ['periodic', 'onetime'].include?(part)
              next if (current_depended_on_services & prev_tarif_set_services).blank?
              service_categories_for_fixed[part][service_id][:service_categories_with_options].keys.flatten.uniq if service_categories_for_fixed[part].try(:[], service_id)
            else
              current_depended_on_services 
            end
  
            if ['periodic', 'onetime'].include?(part)
              tarif_set_stat[:depended_on_services] ||= []
              tarif_set_stat[:depended_on_services] += (current_depended_on_services - tarif_set_stat[:depended_on_services]) if !item[:service_categories_with_options].blank?
              tarif_set_stat[:depended_on_services].sort!
            end
          end
          
          service_category_ids = if ['periodic', 'onetime'].include?(part)
            service_categories_for_fixed[part][service_id][:service_categories] + 
              service_categories_dependent_on_prev_services(prev_tarif_set_services, service_categories_for_fixed[part][service_id][:service_categories_with_options])
          else
            item[:service_categories] + service_categories_dependent_on_prev_services(prev_tarif_set_services, item[:service_categories_with_options])          
          end
          service_category_ids.uniq!
          chosen_service_categories = service_category_ids.map{|id| service_categories[id.to_s]}
          
          begin  

            price, stat_params = call_by_id(item[:standard_formula_id], current_stat, tarif_set_stat, item[:params], chosen_service_categories, item[:window_over])

            price = 0.0 if tarif_set_stat[:is_service_a_tarif] and part == 'onetime'            
            
            result += price

            if if_save_stat
              stat[calculation_order] ||= {}
              stat[calculation_order][service_category_group_id] ||= {}
              categ_ids = []
              if ['periodic', 'onetime'].include?(part)
                categ_ids = item[:service_categories] + service_categories_dependent_on_prev_services(prev_tarif_set_services, item[:service_categories_with_options])
                stat[calculation_order][service_category_group_id][:service_categories] = categ_ids.map{|id| service_categories[id.to_s]}
              else
                categ_ids = service_category_ids
                stat[calculation_order][service_category_group_id][:service_categories] = chosen_service_categories
              end             
              stat[calculation_order][service_category_group_id][:stat_params] = stat_params.merge({'price' => price, 'categ_ids' => categ_ids})
            end

            raise(StandardError) if false and tarif_set_stat[:is_service_a_tarif] and part == 'onetime' and if_save_stat and price > 0.0
            
            formula_name = formula_name_from_formula_id(item[:standard_formula_id])

          end
        end
      end if formula_params[part].try(:[], service_id)
      [result, stat]
    end    
    
    def init_tarif_cost_calculator_general(options)
      service_ids = tarif_list_generator.all_services
      @service_categories = service_category_tarif_classes(service_ids)
      rows = service_category_tarif_classes_and_formula_params_sql(service_ids)
      @formula_params = service_category_tarif_classes_and_formula_params(rows)
      @service_categories_for_fixed = service_category_tarif_classes_for_fixed(rows)
    end
    
    def init_tarif_cost_calculator_stat(options)
      service_ids = tarif_list_generator.all_services
      global_category_where_hash = Optimization::Global::Base.new(options).filtr_from_global_category_names(options[:user_input][:selected_service_categories])
      call_run_id = options[:user_input][:call_run_id]
      accounting_period = options[:user_input][:accounting_period]
      calls = Customer::Call.base_customer_call_sql(call_run_id, accounting_period).where(global_category_where_hash)

      global_stater = ::Optimizator::Global::Stat.new(options)
      @global_stat = global_stater.all_global_categories_stat(calls, service_ids)
      @global_category_by_parts = global_stater.global_category_by_parts(service_ids)      
    end
    
    def service_categories_dependent_on_prev_services(prev_services, dependent_categories)
      result = []
      dependent_categories.each do |tarif_option_ids, service_categories|
        result += service_categories if (tarif_option_ids - prev_services).blank? and !(prev_services & tarif_option_ids).blank?
#        result += service_categories if !(prev_services & tarif_option_ids).blank?
      end
      result
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
