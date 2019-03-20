module Optimization
  class TarifsCostCalculator
    attr_reader :formula_params, :service_categories_for_fixed, :global_stat, :global_category_by_parts, :service_categories
    attr_reader :options
    include Optimization::Global::StandardFormulas
    
    def initialize(options = {})
      @options = options
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
      result = 0.0; stat = {}
  #    return result if ["mms", "all-world-rouming/mms", "all-world-rouming/mobile-connection", "all-world-rouming/calls", "all-world-rouming/sms"].include?(part)
      current_stat = ['periodic', 'onetime'].include?(part) ? global_stat.deep_dup : global_stat.slice(*global_category_by_parts[part]).deep_dup      
      reversed_services = services.reverse
      tarif_set_stat = {}
      reversed_services.each_with_index do |service_id, service_index|
        prev_tarif_set_services = service_index == 0 ? [] : reversed_services[0..service_index - 1]
        tarif_set_stat[:service_id] = service_id; tarif_set_stat[:prev_service_ids] = prev_tarif_set_services;
        stat_before = current_stat.deep_dup
        s_before = result
        s, stat_params = calculate_tarif_set_service(current_stat, tarif_set_stat, part, service_id, prev_tarif_set_services, if_save_stat)      
        stat[service_id] = stat_params if if_save_stat
        raise(StandardError, [
          
        ]) if false and part == "own-country-rouming/sms" and service_id == 861
        result += s
      end
      [result, current_stat, stat]
    end
    
    def calculate_tarif_set_service(current_stat, tarif_set_stat, part, service_id, prev_tarif_set_services, if_save_stat = false)
      result = 0.0; stat = {}
      
      return [result, stat] if current_stat.blank?
      
      formula_params[part][service_id].keys.sort.each do |calculation_order|
        formula_params[part][service_id][calculation_order].each do |service_category_group_id, item|
          is_service_group_depended_on = !item[:service_categories_with_options].blank?
          tarif_set_stat[:current_service_group_dependent_on] = is_service_group_depended_on
          current_depended_on_services = item[:service_categories_with_options].keys.flatten.uniq
          
          if is_service_group_depended_on
            depended_on_services = if ['periodic', 'onetime'].include?(part)
              next if (current_depended_on_services & prev_tarif_set_services).blank?
              service_categories_for_fixed[part][service_id][:service_categories_with_options].keys.flatten.uniq if service_categories_for_fixed[part].try(:[], service_id)
            else
              current_depended_on_services 
            end
  
#            next if !depended_on_services.blank? and (depended_on_services & prev_tarif_set_services).blank?
            if ['periodic', 'onetime'].include?(part)
              tarif_set_stat[:depended_on_services] ||= []
              tarif_set_stat[:depended_on_services] += (current_depended_on_services - tarif_set_stat[:depended_on_services]) if !item[:service_categories_with_options].blank?
              tarif_set_stat[:depended_on_services].sort!
            end
            
            raise(StandardError, [
              depended_on_services, tarif_set_stat[:depended_on_services], current_depended_on_services
            ]) if false and depended_on_services != tarif_set_stat[:depended_on_services] and ['periodic', 'onetime'].include?(part)
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
  #        rescue => e
            formula_name = formula_name_from_formula_id(item[:standard_formula_id])

          end
        end
      end if formula_params[part].try(:[], service_id)
      [result, stat]
    end
    
    def init_tarif_cost_calculator(preloaded_data = nil, general_preloaded_data_by_operator = nil, specific_preloaded_data_by_operator = nil, preloaded_data_by_tarif = nil)
#      @service_categories = preloaded_data['service_category_tarif_classes']
      @service_categories = preloaded_data_by_tarif['service_category_tarif_classes']
      @formula_params = preloaded_data_by_tarif['formula_params']
      @service_categories_for_fixed = preloaded_data_by_tarif['service_categories_for_fixed']
      @global_stat = specific_preloaded_data_by_operator['global_stat']
      @global_category_by_parts = general_preloaded_data_by_operator['global_category_by_parts']
    end
    
    def service_categories_dependent_on_prev_services(prev_services, dependent_categories)
      result = []
      dependent_categories.each do |tarif_option_ids, service_categories|
        result += service_categories if !(prev_services & tarif_option_ids).blank?
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
