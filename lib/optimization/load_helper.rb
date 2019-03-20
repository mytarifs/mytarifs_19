module Optimization
  module LoadHelper
    def calculate_general_preloaded_data_for_optimization_for_operator(tarif_set_services)
      global_stat = Optimization::Global::Stat.new              
      general_preloaded_data = {}
      
      general_preloaded_data['stat_params_by_global_category'] = global_stat.stat_params_by_global_category(tarif_set_services)
      general_preloaded_data['global_category_by_parts'] = global_stat.global_category_by_parts(tarif_set_services)
      general_preloaded_data['stat_params_grouped_by_period'] = global_stat.stat_params_grouped_by_period(tarif_set_services)
      general_preloaded_data['service_categories_by_global_category'] = global_stat.load_service_categories_by_global_category(tarif_set_services)
      general_preloaded_data['all_services_by_operator'] = tarif_set_services
      
      general_preloaded_data
    end
    
    def calculate_general_preloaded_data_for_optimization_for_tarif(operator_id, tarif_id, tarif_list_generator)
      preloaded_data = {}
      preloaded_data['service_packs_by_parts'] = tarif_list_generator.service_packs_by_parts[tarif_id]
      preloaded_data['tarif_sets'] = tarif_list_generator.tarif_sets[tarif_id]
      preloaded_data['allowed_common_services'] = tarif_list_generator.allowed_common_services[tarif_id]
      preloaded_data['services_that_depended_on'] = tarif_list_generator.services_that_depended_on
      
      rows = service_category_tarif_classes_and_formula_params_sql(tarif_list_generator.service_packs[tarif_id])
      preloaded_data['formula_params'] = service_category_tarif_classes_and_formula_params(rows)
      preloaded_data['service_categories_for_fixed'] = service_category_tarif_classes_for_fixed(rows)
      
      preloaded_data['service_category_tarif_classes'] = load_service_category_tarif_classes(tarif_list_generator.service_packs[tarif_id])
      preloaded_data
    end

    def calculate_specific_preloaded_data_for_optimization_for_operator(general_preloaded_data_for_operator, global_categories)
      tarif_set_services = general_preloaded_data_for_operator['all_services_by_operator']
      global_category_where_hash = Optimization::Global::Base.new().filtr_from_global_category_names(global_categories)

      call_run_id = options[:user_input][:call_run_id]
      accounting_period = options[:user_input][:accounting_period]
      calls = Customer::Call.base_customer_call_sql(call_run_id, accounting_period).where(global_category_where_hash)

      specific_preloaded_data = {}
      global_stat = Optimization::Global::Stat.new(options)
      global_stat.init_global_stat(general_preloaded_data_for_operator)
      specific_preloaded_data['global_stat'] = global_stat.all_global_categories_stat(calls, tarif_set_services)
      specific_preloaded_data
    end
    
    def calculate_general_preloaded_data_for_optimization
      preloaded_data = {}
      load_service_categories(preloaded_data)
      load_service_criteria_by_service_category(preloaded_data)
      load_general_categories(preloaded_data)
      preloaded_data
    end
    
    def load_service_categories(preloaded_data)
      categories_as_hash = {}
      Service::Category.find_each do |c|
        categories_as_hash[c.id.to_s] = {'id'.freeze => c.id, 'name'.freeze => c.name,}
      end  
      preloaded_data['service_categories'] =  categories_as_hash
    end

    def load_service_criteria_by_service_category(preloaded_data)
      criteria_as_hash = {}
      Service::Criterium.find_each do |c|
        criteria_as_hash[c.service_category_id.to_s] = {'value' => c.value, 'eval_string' => c.eval_string}
      end  
      preloaded_data['service_criteria_by_service_category'] =  criteria_as_hash
    end

    def load_general_categories(preloaded_data)
      general_categories_as_hash = {}
      Category.find_each do |c|
        general_categories_as_hash[c.id.to_s] = c 
      end  
      preloaded_data['general_categories'] =  general_categories_as_hash
    end

    def load_service_category_tarif_classes(service_ids)
      service_category_tarif_classes_as_hash = {}
      fields_to_load = %w(id service_category_one_time_id service_category_periodic_id uniq_service_category filtr).map{|f| "service_category_tarif_classes.#{f}"}
      Service::CategoryTarifClass.joins(:as_standard_category_group).where(:tarif_class_id => service_ids).select(fields_to_load.join(', ')).find_each do |c|
#      Service::CategoryTarifClass.joins(:as_standard_category_group).where(:service_category_groups => {:tarif_class_id => service_ids}).select(fields_to_load.join(', ')).find_each do |c|
        service_category_tarif_classes_as_hash[c.id.to_s] = c.attributes
      end  
      service_category_tarif_classes_as_hash
    end

    def service_category_tarif_classes_and_formula_params(rows)
      result = {}
      rows.find_each do |item|
        result[item.part] ||= {}
        result[item.part][item.service_id] ||= {}
        result[item.part][item.service_id][item.calculation_order] ||= {}
        result[item.part][item.service_id][item.calculation_order][item.service_category_group_id] ||= {}
        result_item = result[item.part][item.service_id][item.calculation_order][item.service_category_group_id]
        
        result_item[:service_categories] ||= []
        result_item[:service_categories_with_options] ||= {}
        if item.tarif_set_must_include_tarif_options.blank?
          result_item[:service_categories] << item.service_category_tarif_classes_id
        else
          item.tarif_set_must_include_tarif_options.each do |tarif_option_id|
            result_item[:service_categories_with_options] ||= {}
            result_item[:service_categories_with_options][item.tarif_set_must_include_tarif_options] ||= []
            result_item[:service_categories_with_options][item.tarif_set_must_include_tarif_options] << item.service_category_tarif_classes_id
          end
        end
        next if result_item[:standard_formula_id]
        result_item[:standard_formula_id] = item.standard_formula_id
        result_item[:params] = item.params
        result_item[:window_over] = item.window_over
      end
      result
    end    
    
    def service_category_tarif_classes_for_fixed(rows)
      result = {}
      ['periodic', 'onetime'].each do |part|
        rows.find_each do |item|
          result[part] ||= {}
          result[part][item.service_id] ||= {}
          result_item = result[part][item.service_id]
          
          result_item[:service_categories] ||= []
          result_item[:service_categories_with_options] ||= {}
          if item.tarif_set_must_include_tarif_options.blank?
            result_item[:service_categories] << item.service_category_tarif_classes_id
          else
            item.tarif_set_must_include_tarif_options.each do |tarif_option_id|
              result_item[:service_categories_with_options] ||= {}
              result_item[:service_categories_with_options][item.tarif_set_must_include_tarif_options] ||= []
              result_item[:service_categories_with_options][item.tarif_set_must_include_tarif_options] << item.service_category_tarif_classes_id
            end
          end
        end
      end
      result
    end    
    
    def service_category_tarif_classes_and_formula_params_sql(service_ids)
      fields = [
        "service_category_groups.id",
        "service_category_groups.id as service_category_group_id",
        "service_category_groups.tarif_class_id as service_id",
        'service_category_tarif_classes.id as service_category_tarif_classes_id',
        "service_category_tarif_classes.conditions#>>'{parts, 0}' as part",
        "(service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options')::jsonb as tarif_set_must_include_tarif_options",
        'price_formulas.calculation_order',
        "price_formulas.standard_formula_id",
        "(price_formulas.formula#>>'{params}')::jsonb as params",
        "price_formulas.formula#>>'{window_over}' as window_over",
      ]
      Service::CategoryGroup.where(:tarif_class_id => service_ids).
        joins(:service_category_tarif_classes, price_lists: :formulas).select(fields).
        order("price_formulas.calculation_order, service_category_groups.id, service_category_tarif_classes.id")
    end
    

  end  
end
