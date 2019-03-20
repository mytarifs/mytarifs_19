module Optimization::Global
  class Stat < Optimization::Global::Base
    attr_reader :stat_params_by_global_category, :global_category_by_parts, :stat_params_grouped_by_period, :service_categories_by_global_category
    def initialize(options = {})
      super
    end
    
    def init_global_stat(general_preloaded_data_for_operator)
      @stat_params_by_global_category = general_preloaded_data_for_operator['stat_params_by_global_category'] 
      @global_category_by_parts = general_preloaded_data_for_operator['global_category_by_parts']
      @stat_params_grouped_by_period = general_preloaded_data_for_operator['stat_params_grouped_by_period']
      @service_categories_by_global_category = general_preloaded_data_for_operator['service_categories_by_global_category']      
    end
    
    def test_all_global_categories_stat
      calls = Customer::Call.where(:call_run_id => 553)
      accounting_period = calls.first.description['accounting_period']
      calls = calls.where("description->>'accounting_period' = '#{accounting_period}'")
      res = all_global_categories_stat(calls, [])
  #    res.map{|gl| gl[1]["aggregated"][-1]["call_id_count"] }.sum
  #    all_global_categories_stat_sql(calls, [674], 'day', true)
    end
    
    def all_global_categories_stat(calls, service_ids = [])
      loaded_service_categories = load_service_categories_by_global_category(service_ids)
      sql = ['day', 'month'].map do |group_period|
        [true, false].map do |detailed|
          all_global_categories_stat_sql(calls, service_ids, group_period, detailed).map{|global_name, r| r if r }
        end
      end.flatten.compact.join(" union all ")
      
      rows = calls.find_by_sql("with base_calls as (#{calls.to_sql}) #{sql}")
      
      global_stat = detailed_global_categories_stat(rows, loaded_service_categories, service_ids)
      aggregated_global_categories_stat(rows, loaded_service_categories, global_stat, service_ids)

      global_stat
    end
    
    def aggregated_global_categories_stat(rows, loaded_service_categories, global_stat, service_ids = [])
      detailed = false
      ['day', 'month'].each do |group_period|
        rows.each do |row|
          day_index = row.day.to_i
          next if row.global_name.blank?
          next if row.detailed
          next if group_period != row.period
          category_ids_without_filtr = loaded_service_categories[row.global_name]["without_filtr"].map{|sc| sc['id']}
          global_stat[row.global_name].extract!("with_false_filtr")
          row['stat_params'].each do |stat_param_name, stat_param_value|
            if stat_param_value.is_a?(Hash)
              global_stat[row.global_name]["aggregated"][:[]][stat_param_name] ||= {}
              stat_param_value.each do |k, v|
                global_stat[row.global_name]["aggregated"][:[]][stat_param_name][k] ||= []
                global_stat[row.global_name]["aggregated"][:[]][stat_param_name][k][day_index] = v
              end
            else
              global_stat[row.global_name]["aggregated"][:[]][stat_param_name] ||= []
              global_stat[row.global_name]["aggregated"][:[]][stat_param_name][day_index] = stat_param_value
            end
          end
          next if category_ids_without_filtr.blank?
          global_stat[row.global_name]["without_filtr"][category_ids_without_filtr] ||= {}
          row['stat_params'].each do |stat_param_name, stat_param_value|
            if stat_param_value.is_a?(Hash)
              global_stat[row.global_name]["without_filtr"][category_ids_without_filtr][stat_param_name] ||= {}
              stat_param_value.each do |k, v|
                global_stat[row.global_name]["without_filtr"][category_ids_without_filtr][stat_param_name][k] ||= []
                global_stat[row.global_name]["without_filtr"][category_ids_without_filtr][stat_param_name][k][day_index] = v
              end
            else
              global_stat[row.global_name]["without_filtr"][category_ids_without_filtr][stat_param_name] ||= []
              global_stat[row.global_name]["without_filtr"][category_ids_without_filtr][stat_param_name][day_index] = stat_param_value
            end
          end
          raise(StandardError) if global_stat[row.global_name]["without_filtr"][category_ids_without_filtr] != global_stat[row.global_name]["aggregated"][:[]]
        end
      end
    end
    
    def detailed_global_categories_stat(rows, loaded_service_categories, service_ids = [])
      result = {}
      detailed = true
      ['day', 'month'].each do |group_period|
        rows.each do |row|
          day_index = row.day.to_i
          next if row.global_name.blank?
          next if !row.detailed
          next if group_period != row.period
          service_categories_by_global_category = loaded_service_categories[row.global_name]["with_filtr"]        
          category_ids_with_filtr = category_ids_for_global_category_stat(service_categories_by_global_category, row["filtr_params"], row)
          result[row.global_name] ||= {"with_filtr" => {}, "with_false_filtr" => {}, "without_filtr" => {}, "aggregated" => {:[] => {}}}
          if !category_ids_with_filtr[true].blank?
            result[row.global_name]["with_filtr"][category_ids_with_filtr[true]] ||= {}
            row['stat_params'].each do |stat_param_name, stat_param_value|
              if stat_param_value.is_a?(Hash)
                result[row.global_name]["with_filtr"][category_ids_with_filtr[true]][stat_param_name] ||= {}              
                stat_param_value.each do |k, v|                 
                  result[row.global_name]["with_filtr"][category_ids_with_filtr[true]][stat_param_name][k] ||= []
                  result[row.global_name]["with_filtr"][category_ids_with_filtr[true]][stat_param_name][k][day_index] ||= 0.0
                  result[row.global_name]["with_filtr"][category_ids_with_filtr[true]][stat_param_name][k][day_index] += v
                end
              else
                result[row.global_name]["with_filtr"][category_ids_with_filtr[true]][stat_param_name] ||= []
                result[row.global_name]["with_filtr"][category_ids_with_filtr[true]][stat_param_name][day_index] ||= 0.0
                result[row.global_name]["with_filtr"][category_ids_with_filtr[true]][stat_param_name][day_index] += stat_param_value
              end
            end          
          end
          if !category_ids_with_filtr[false].blank?
            result[row.global_name]["with_false_filtr"][category_ids_with_filtr[false]] ||= []
            result[row.global_name]["with_false_filtr"][category_ids_with_filtr[false]][day_index] ||= {}
          end
        end
      end
      result 
    end
    
    def category_ids_for_global_category_stat(service_categories_by_global_category, global_category_filtr = nil, row = nil)
      result = {true => [], false => []}
      service_categories_by_global_category.each do |sc|
        raise(StandardError, [sc.attributes, "#########", 
          global_category_filtr, "########", sc.filtr]) if false and sc['name'] == '_sctcg_mts_sic_135_to_other_countries_calls_to_not_rouming_not_russia_not_sic'
        if global_category_filtr and sc['filtr']
          if Optimization::Global::Base::CategoryFiltr.new.filtr_for_stat(global_category_filtr, sc['filtr'])
            result[true] << sc['id'] 
          else
            result[false] << sc['id']
          end
        end
      end          
      result
    end
    
    def load_service_categories_by_global_category(service_ids = [])
      return @service_categories_by_global_category if @service_categories_by_global_category
      result = {}
      base_service_category = Service::CategoryTarifClass.where.not(:uniq_service_category => [nil, ''])
      base_service_category = base_service_category.includes(:as_standard_category_group).
        joins(:as_standard_category_group).where(:service_category_groups => {:tarif_class_id => service_ids}) if !service_ids.blank?
      base_service_category.find_each do |sc|
        next if sc.uniq_service_category.blank?
        result[sc.uniq_service_category] ||= {"with_filtr" => [], "without_filtr" => []} 
        if sc.filtr.blank?
          result[sc.uniq_service_category]["without_filtr"] << {'id' => sc.id, 'filtr' => sc.filtr}
        else
          result[sc.uniq_service_category]["with_filtr"] << {'id' => sc.id, 'filtr' => sc.filtr}
        end      
      end
      result
    end
    
    def all_global_categories_stat_sql(calls, service_ids = [], group_period = 'month', detailed = false)
      result = {}
      standard_stat_params = ["count(*) as call_id_count"]
      stat_params_grouped_by_period(service_ids).map do |global_name, stat_params|
        params = params_from_global_name(global_name)
  #      next if stat_params[group_period].blank? and !(detailed == false and group_period == 'day')
        full_stat_params = standard_stat_params + (group_period == 'month' ? stat_params['month'] : stat_params['day'])
        result[global_name] = one_global_category_stat_sql(calls, full_stat_params, params, group_period, detailed)
      end
  #    raise(StandardError, [stat_params_grouped_by_period(service_ids), result]) if group_period == 'day'
      result
    end    
    
    def one_global_category_stat_sql(calls, stat_params, params, group_period = 'month', detailed = false)
      cat_name = "('#{global_name(params)}')::text as global_name"
      period_fields = group_period == 'month' ? ["#{detailed} as detailed", "'#{group_period}' as period", "'0' as day", "description->>'month' as month"] : 
        ["#{detailed} as detailed", "'#{group_period}' as period", "description->>'day' as day", "description->>'month' as month"]
      fields = [[cat_name] + period_fields + [stat_params_as_json(stat_params)]] + 
        (detailed ? [stat_params_as_json(call_group.fields_with_name(params), 'filtr_params')] : ["'{}' as filtr_params"])
      fields = fields.join(", ") 
  #    period_where_hash = group_period == 'month' ?  "true" : "description->>'day' = '#{group_period}'" 
      where_hash = call_filtr.filtr(params)
      group_by = (['day', 'month'] + (detailed ? call_group.group_fields(params) : [])).join(', ')
#      calls.select(fields).where(where_hash).group(group_by)#.group(group_period)
      "select #{fields} from base_calls where #{where_hash} group by #{group_by}"
    end
    
    def stat_params_as_json(stat_params, name = 'stat_params')
      items = []
      stat_params.each do |stat_param|
        parts = stat_param.split(' as ')
        items << "'#{parts[1]}'" << parts[0]
      end
      "json_build_object(#{items.join(', ')}) as #{name}"
    end
  
    def stat_params_grouped_by_period(service_ids = [])
      return @stat_params_grouped_by_period if @stat_params_grouped_by_period
      @stat_params_grouped_by_period = {}
      stat_params_by_global_category(service_ids).each do |stat_params_by_global_category|
        day_group = stat_params_by_global_category['window_over'] if stat_params_by_global_category['window_over']
  #      day_group = stat_params_by_global_category['window_over'] == 'day' ? 'day' : nil
        global_category = stat_params_by_global_category["uniq_service_category"]
        @stat_params_grouped_by_period[global_category] ||= {'day' => [], 'month' => []}
        stat_params_by_global_category["arr_of_stat_params"].each do |stat_param|
          stat_param.each do |name, desc|        
            @stat_params_grouped_by_period[global_category]['month'] << "#{desc['formula']} as #{name}"
            @stat_params_grouped_by_period[global_category]['day'] << "#{desc['formula']} as #{name}" if day_group or desc.try(:[], 'group_by') == 'day'
          end
        end
      end    
      @stat_params_grouped_by_period
    end
    
    def global_category_by_parts(service_ids = [])
      return @global_category_by_parts if @global_category_by_parts
      result = {}
      base = service_ids.blank? ? Service::CategoryTarifClass : 
        Service::CategoryTarifClass.joins(:as_standard_category_group).where(:service_category_groups => {:tarif_class_id => service_ids})
      base.select("array_agg(distinct uniq_service_category) as global_categories, service_category_tarif_classes.conditions#>>'{parts, 0}' as part").
        group("part").each do |item|
        result[item.part] ||= []
        result[item.part] = item.global_categories
      end
      result
    end
    
    def stat_params_by_global_category(service_ids = [], id = nil)
      return @stat_params_by_global_category if @stat_params_by_global_category
      base_service_category = service_ids.blank? ? Service::CategoryGroup : Service::CategoryGroup.where(:tarif_class_id => service_ids)
      base_service_category.where.not(:service_category_tarif_classes => {:uniq_service_category => [nil, '']}).
  #      where(:service_category_tarif_classes => {:id => id}).
        joins(:service_category_tarif_classes, price_lists: [formulas: :standard_formula]).
        select(:uniq_service_category, "array_agg(distinct stat_params) as arr_of_stat_params, price_formulas.formula->>'window_over' as window_over").
        group(:uniq_service_category, :window_over)
    end
  end      
end
