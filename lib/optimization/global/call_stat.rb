module Optimization::Global
  class CallStat < Optimization::Global::Base
    
    def initialize(options = {})
      super
    end
    
    def test
      calls = Customer::Call.where(:call_run_id => 553)
      accounting_period = calls.first.description['accounting_period']
      calls = calls.where("description->>'accounting_period' = '#{accounting_period}'")
      res = calculate_calls_stat(calls)
  #    res.map{|gl| gl[1]["aggregated"][-1]["call_id_count"] }.sum
  #    all_global_categories_stat_sql(calls, [674], 'day', true)
    end
  
    #Optimization::Global::CallStat.new.groupped_global_categories
    def groupped_global_categories(group_by_1 = [])
      group_by = group_by_1.blank? ? category_group_keys : group_by_1
      result_hash = {}
  #    Optimization::Global::Base::Structure.each do |calls_stat_category_id, category|
      iterate_with_index do |index, rouming, service, destination, partner, final_category|
        params = [rouming, service, destination, partner, final_category].compact
        changed_params = if false and service
          splitted_service = service.to_s.split("_")
          [rouming, splitted_service[0], splitted_service[1], destination, partner, final_category].compact
        else
          [rouming, service, destination, partner, final_category].compact
        end.compact
        
        name = {}; group_name = {}
        
        group_by.each do |group|
          if category_group_indexes[group] and changed_params
            name[group] = tr(changed_params[category_group_indexes[group]]) 
            group_name[group] = changed_params[category_group_indexes[group]] 
          end
        end
  
        name_string = group_name.values.compact.join("_")
        name_string = '' if name_string.blank?
  #      raise(StandardError, [name_string, name])
        result_hash[name_string] ||= name.merge({'name_string'.freeze => name_string, 'categ_ids'.freeze => []})
        result_hash[name_string]['categ_ids'.freeze] += (([index] || []) - result_hash[name_string]['categ_ids'.freeze])
      end
      result_hash[''] ||= {'name_string'.freeze => 'fixed_payments', 'categ_ids'.freeze => []}
      raise(StandardError, result_hash) if false
      result_hash
    end
    
    def global_categories_by_service_category_hash(service_ids)
      result = {}
      Service::CategoryTarifClass.joins(:as_standard_category_group).where(:service_category_groups => {:tarif_class_id => service_ids}).
        select("service_category_tarif_classes.id, service_category_tarif_classes.uniq_service_category").each do |item|
          result[item.id] = item.uniq_service_category
      end
      result
    end
    
    def global_category_group_name(global_category_name, group_by_1 = [])
      group_by = group_by_1.blank? ? category_group_keys : group_by_1
      global_category = (global_category_name || '').split("/")
      
  
      result = group_by.collect do |group|
        global_category[category_group_indexes[group]] if category_group_indexes[group] and global_category
      end.compact.join('_'.freeze) 
      raise(StandardError, [
        result, group_by, global_category
      ]) if false
      result
    end
    
    def category_group_indexes
      {'rouming'.freeze => 0, 'service'.freeze => 1, 'direction'.freeze => 2, 'geo'.freeze => 3, 'operator'.freeze => 4, 'fixed'.freeze => 5}
    end
    
    def calculate_calls_stat(calls)
      sql = calculate_calls_stat_sql(calls)      
      Customer::Call.find_by_sql(sql) unless sql.blank?
    end
    
    def calculate_calls_stat_sql(calls)
      calls_stat_category_sql = []
      iterate_with_index do |index, rouming_country, rouming_region, service, destination, partner, final_category|
        params = [rouming_country, rouming_region, service, destination, partner, final_category].compact
        call_types = params.map{|s| "\"#{s}\"".freeze}.join(', '.freeze); 
        call_types_filed = "'[#{call_types}]' as call_types".freeze
        where_hash = call_filtr.filtr(params)
        raise(StandardError, [params, where_hash]) if false and index == 1
        fields = calls_stat_functions_with_name(calls_stat_functions) + 
          [call_types_filed, "'#{global_name(params)}' as global_name", "#{index} as global_category_id", "true as new_optimization"]
        calls_stat_category_sql << calls.select(fields.join(', '.freeze)).where(where_hash).to_sql
      end
      calls_stat_category_sql.join(' union '.freeze)
    end
  
    def calls_stat_functions_with_name(stat_functions_as_hash)
      items = []
      stat_functions_as_hash.each do |stat_param_name, formula|
        items << "#{formula} as #{stat_param_name}"
      end
      items
    end
  
    def calls_stat_functions
      {
        :count => "count(*)".freeze,
        :sum_duration => "sum((description->>'duration')::float)/60.0".freeze,
        :count_volume => "count(description->>'volume')".freeze,
        :sum_volume => "sum((description->>'volume')::float)".freeze,
       }
    end  
  
    def tr(word)
      Optimization::Global::Base::Dictionary.tr(word)
    end
  end
end
