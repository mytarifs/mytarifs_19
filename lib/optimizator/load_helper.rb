module Optimizator
  module LoadHelper
    def service_categories
      categories_as_hash = {}
      Service::Category.find_each do |c|
        categories_as_hash[c.id.to_s] = {'id'.freeze => c.id, 'name'.freeze => c.name,}
      end  
      categories_as_hash
    end

    def service_criteria_by_service_category
      criteria_as_hash = {}
      Service::Criterium.find_each do |c|
        criteria_as_hash[c.service_category_id.to_s] = {'value' => c.value, 'eval_string' => c.eval_string}
      end  
      criteria_as_hash
    end

    def general_categories
      general_categories_as_hash = {}
      Category.find_each do |c|
        general_categories_as_hash[c.id.to_s] = c 
      end  
      general_categories_as_hash
    end

    def service_category_tarif_classes(service_ids)
      service_category_tarif_classes_as_hash = {}
      m_region_id = tarif_list_generator.m_region_id
      fields_to_load = %w(id service_category_one_time_id service_category_periodic_id uniq_service_category filtr).map{|f| "service_category_tarif_classes.#{f}"}
      Service::CategoryTarifClass.
        joins(as_standard_category_group: [price_lists: :formulas]).
        where("#{Service::CategoryTarifClass.regions_sql(m_region_id)}").
        where("#{Price::Formula.regions_sql(m_region_id)}").
        where(:tarif_class_id => service_ids).select(fields_to_load.join(', ')).find_each do |c|
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
      m_region_id = tarif_list_generator.m_region_id
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
      result = Service::CategoryGroup.
        where(:tarif_class_id => service_ids).
        joins(:service_category_tarif_classes, price_lists: :formulas).
        where("#{Service::CategoryTarifClass.regions_sql(m_region_id)}").
        where("#{Price::Formula.regions_sql(m_region_id)}").
        select(fields).
        order("price_formulas.calculation_order, service_category_groups.id, service_category_tarif_classes.id")
      raise(StandardError) if false 
      result 
    end
    

  end  
end
