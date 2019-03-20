module Optimization::Global
  module StandardFormulasHelper
#  module ClassMethods
#  extend ActiveSupport::Concern
  
    def tarif_set_stat_by_month(tarif_set_stat, fixed_type)
      fixed_type = tarif_set_stat[:current_service_group_dependent_on] ? "#{fixed_type}_dependent_on".to_sym : "#{fixed_type}_non_dependent_on".to_sym
      tarif_set_stat[fixed_type] ||= []
      new_fixed_services_by_month = tarif_set_stat[:depended_on_services] - tarif_set_stat[fixed_type]
      raise(StandardError, [tarif_set_stat, new_fixed_services_by_month]) if false and new_fixed_services_by_month.blank?
      tarif_set_stat[fixed_type] += (tarif_set_stat[:depended_on_services] - tarif_set_stat[fixed_type])
      new_fixed_services_by_month
    end

    def tarif_set_stat_by_day(tarif_set_stat, fixed_type, non_zero_days)
      fixed_type = tarif_set_stat[:current_service_group_dependent_on] ? "#{fixed_type}_dependent_on".to_sym : "#{fixed_type}_non_dependent_on".to_sym
      depended_on_services = tarif_set_stat[:depended_on_services]
      tarif_set_stat[fixed_type] ||= {}
      tarif_set_stat[fixed_type][depended_on_services] ||= []
      new_non_zero_days = non_zero_days - tarif_set_stat[fixed_type][depended_on_services]
      tarif_set_stat[fixed_type][depended_on_services] += new_non_zero_days
      new_non_zero_days
    end

    def days_with_non_zero_call_id_count(stat, service_categories)
      non_zero_days = []
      iterate(stat, service_categories) do |filtr_type, service_category, global_name, category_ids_key|
        new_non_zero_days = []         
        stat[global_name][filtr_type][category_ids_key]["call_id_count"][1..-1].each_with_index{|v, i| new_non_zero_days << (i + 1) if v} if filtr_type
        non_zero_days += (new_non_zero_days - non_zero_days)
      end
      non_zero_days#.compact.uniq.size
    end
    
    def check_if_call_id_count_is_non_zero(stat, service_categories, period = 0)
      iterate(stat, service_categories) do |filtr_type, service_category, global_name, category_ids_key|
        if filtr_type
          return true if stat[global_name][filtr_type][category_ids_key]["call_id_count"][period] > 0.0
        end
      end
      false
    end      
    
    def stat_params_from_global_with_day_limit_average(stat, stat_param_names, service_categories, limit_param_name, limit)
      stat_params = {}; used_global_categories = {}
      stat_param_names.each{|stat_param_name| stat_params[stat_param_name] = 0.0}
      (0..31).each do |period|
        accumulated_limit = 0.0
        next if period == 0 or accumulated_limit >= limit
        full_param_value = 0.0
        iterate(stat, service_categories) do |filtr_type, service_category, global_name, category_ids_key|  
          if filtr_type
            full_param_value += (stat[global_name][filtr_type][category_ids_key][limit_param_name][period] || 0.0)
          end
        end
        used_share = (full_param_value == 0.0 ? 1.0 : limit / full_param_value)
        iterate(stat, service_categories) do |filtr_type, service_category, global_name, category_ids_key|  
          if filtr_type
            used_global_categories[global_name] ||= {}        
            used_global_categories[global_name][filtr_type] ||= {}
            used_global_categories[global_name][filtr_type][category_ids_key] ||= []

            used_global_categories[global_name][filtr_type][category_ids_key][period] = used_share
            stat_param_names.each do |stat_param_name| 
              process_stat_param_value(stat[global_name][filtr_type][category_ids_key][stat_param_name]) do |key, stat_param_value|
                if key
                  stat_params[stat_param_name] = {} if !stat_params[stat_param_name].is_a?(Hash)
                  stat_params[stat_param_name][key] ||= 0.0
                  stat_params[stat_param_name][key] += (stat_param_value[period] || 0.0) * used_share
                else
                  stat_params[stat_param_name] += (stat_param_value[period] || 0.0) * used_share
                end
              end
            end
          end
        end
      end
      calculate_total_used_share_by_service_category(stat, service_categories, used_global_categories, limit_param_name)
#      raise(StandardError, [stat_params, used_global_categories, "############", stat["own_and_home_regions/calls_out/to_own_and_home_regions/to_operators"]])
      [stat_params, used_global_categories]
    end

    def stat_params_from_global_with_day_limit(stat, stat_param_names, service_categories, limit_param_name, limit)
      stat_params = {}; used_global_categories = {}
      stat_param_names.each{|stat_param_name| stat_params[stat_param_name] = 0.0}
      (0..31).each do |period|
        accumulated_limit = 0.0
        next if period == 0 or accumulated_limit >= limit
        iterate(stat, service_categories) do |filtr_type, service_category, global_name, category_ids_key|  
          if filtr_type
            used_global_categories[global_name] ||= {}        
            used_global_categories[global_name][filtr_type] ||= {}
            used_global_categories[global_name][filtr_type][category_ids_key] ||= []
  
            raise(StandardError, [global_name, stat[global_name]]) if stat[global_name][filtr_type][category_ids_key][limit_param_name][1..-1].size == 0
  
            limit_param_value_by_period = (stat[global_name][filtr_type][category_ids_key][limit_param_name][period] || 0.0)
            raise(StandardError, [limit_param_value_by_period, limit]) if [limit_param_value_by_period, limit].compact.size < 2
            used_value = [limit_param_value_by_period, limit - accumulated_limit].min
            accumulated_limit += used_value
            used_share = (limit_param_value_by_period == 0.0 ? 1.0 : used_value / limit_param_value_by_period)

            used_global_categories[global_name][filtr_type][category_ids_key][period] = used_share
            stat_param_names.each do |stat_param_name| 
              process_stat_param_value(stat[global_name][filtr_type][category_ids_key][stat_param_name]) do |key, stat_param_value|
                if key
                  stat_params[stat_param_name] = {} if !stat_params[stat_param_name].is_a?(Hash)
                  stat_params[stat_param_name][key] ||= 0.0
                  stat_params[stat_param_name][key] += (stat_param_value[period] || 0.0) * used_share
                else
                  stat_params[stat_param_name] += (stat_param_value[period] || 0.0) * used_share
                end
              end
            end
          end
        end
      end
      calculate_total_used_share_by_service_category(stat, service_categories, used_global_categories, limit_param_name)
#      raise(StandardError, [stat_params, used_global_categories, "############", stat["own_and_home_regions/calls_out/to_own_and_home_regions/to_operators"]])
      [stat_params, used_global_categories]
    end
    
    def stat_params_from_global_with_month_limit(stat, stat_param_names, service_categories, limit_param_name, limit)
      stat_params = {}; used_global_categories = {}
      stat_param_names.each{|stat_param_name| stat_params[stat_param_name] = 0.0}
      break_condition = false
      accumulated_limit = 0.0
      (0..31).each do |period|
        next if period == 0
        iterate(stat, service_categories) do |filtr_type, service_category, global_name, category_ids_key|  
          if filtr_type
            used_global_categories[global_name] ||= {}        
            used_global_categories[global_name][filtr_type] ||= {}
            used_global_categories[global_name][filtr_type][category_ids_key] ||= []
  
            raise(StandardError, [global_name, stat[global_name]]) if stat[global_name][filtr_type][category_ids_key][limit_param_name][1..-1].size == 0
  
            limit_param_value_by_period = (stat[global_name][filtr_type][category_ids_key][limit_param_name][period] || 0.0)
            used_value = [limit_param_value_by_period, limit - accumulated_limit].min
            accumulated_limit += used_value
            used_share = (limit_param_value_by_period == 0.0 ? 1.0 : used_value / limit_param_value_by_period)

            used_global_categories[global_name][filtr_type][category_ids_key][period] = used_share
            stat_param_names.each do |stat_param_name| 
              process_stat_param_value(stat[global_name][filtr_type][category_ids_key][stat_param_name]) do |key, stat_param_value|
                if key
                  stat_params[stat_param_name] = {} if !stat_params[stat_param_name].is_a?(Hash)
                  stat_params[stat_param_name][key] ||= 0.0
                  stat_params[stat_param_name][key] += (stat_param_value[period] || 0.0) * used_share
                else
                  stat_params[stat_param_name] += (stat_param_value[period] || 0.0) * used_share
                end
              end
            end

            break_condition = true if accumulated_limit >= limit
            break if break_condition      
          end
          break if break_condition
        end
        break if break_condition
      end
      calculate_total_used_share_by_service_category(stat, service_categories, used_global_categories, limit_param_name)
#      raise(StandardError, [stat_params, used_global_categories, "############", stat["own_and_home_regions/calls_out/to_own_and_home_regions/to_operators"]])
      [stat_params, used_global_categories]
    end
    
    def calculate_total_used_share_by_service_category(stat, service_categories, used_global_categories, limit_param_name)
      period = 0
      iterate(stat, service_categories) do |filtr_type, service_category, global_name, category_ids_key|  
        if filtr_type
          next if !used_global_categories[global_name].try(:[], filtr_type).try(:[], category_ids_key) #TODO check when this is needed
          total_param_value = stat[global_name][filtr_type][category_ids_key][limit_param_name][period]
          accumulated_used_value = 0.0           
          used_global_categories[global_name][filtr_type][category_ids_key].each_with_index do |used_share_by_period, period_1|
            next if period_1 == 0 or stat[global_name][filtr_type][category_ids_key][limit_param_name][period_1].blank? or !used_share_by_period
            accumulated_used_value += stat[global_name][filtr_type][category_ids_key][limit_param_name][period_1] * used_share_by_period
          end 
          used_share = (total_param_value == 0.0 ? 1.0 : accumulated_used_value / total_param_value)
          used_global_categories[global_name][filtr_type][category_ids_key][period] = used_share
        end
      end
    end
    
    def clean_daily(stat, used_global_categories)
      used_global_categories.each do |global_name, used_global_category|
        if used_global_category["without_filtr"].blank?
          used_global_category["with_filtr"].each do |category_ids_key, used_values|
            deduct_with_filtr_daily_from_stat_type(stat, global_name, category_ids_key, "without_filtr", used_values)
            deduct_with_filtr_daily_from_stat_type(stat, global_name, category_ids_key, "aggregated", used_values)
            deduct_with_filtr_daily_from_stat_type(stat, global_name, category_ids_key, "with_filtr", used_values)
          end  
        else
          used_global_category["without_filtr"].each do |category_ids_key, used_values|
            clean_with_filtr_daily_after_without_filtr(stat, global_name, category_ids_key, "with_filtr", used_values)
            deduct_without_filtr_daily_from_stat_type(stat, global_name, category_ids_key, "aggregated", used_values)
            deduct_without_filtr_daily_from_stat_type(stat, global_name, category_ids_key, "without_filtr", used_values)
          end          
        end
        extract_global_name_from_stat(stat, global_name)
      end
    end
    
    def extract_global_name_from_stat(stat, global_name)
      stat[global_name]["with_filtr"].each do |category_ids_key, stat_by_category|
        stat[global_name]["with_filtr"].extract!(category_ids_key) if stat[global_name]["with_filtr"][category_ids_key].try(:[], "call_id_count").try(:[], 0) == 0
      end
      stat[global_name]["without_filtr"].each do |category_ids_key, stat_by_category|
        stat[global_name]["without_filtr"].extract!(category_ids_key) if stat[global_name]["without_filtr"][category_ids_key].try(:[], "call_id_count").try(:[], 0) == 0
      end
      if stat[global_name]["with_filtr"].blank? and stat[global_name]["without_filtr"].blank?
#        raise(StandardError, ["error in clean_all funciton", global_name, stat[global_name]] ) if !check_aggregate_for_zero(stat, global_name)
        stat.extract!(global_name) if stat[global_name]["aggregated"][:[]].try(:[], "call_id_count").try(:[], 0) == 0
      end
    end
    
    def clean_with_filtr_daily_after_without_filtr(stat, global_name, category_ids_key, stat_type, used_values)
      stat[global_name][stat_type].keys.each do |with_filtr_key|
        stat[global_name][stat_type][with_filtr_key].keys.each do |stat_param|
          used_values.each_with_index do |used_share_by_period, period|
            process_stat_param_value(stat[global_name][stat_type][with_filtr_key][stat_param]) do |key, stat_param_value|
              next if stat_param_value.blank?
              stat_value_by_period = (stat_param_value[period] || 0.0) * used_share_by_period
              if key
                value_before = stat[global_name][stat_type][with_filtr_key][stat_param][key][period]
                stat[global_name][stat_type][with_filtr_key][stat_param][key][period] -= [stat_value_by_period, value_before].min if value_before
              else
                value_before = stat[global_name][stat_type][with_filtr_key][stat_param][period]
                stat[global_name][stat_type][with_filtr_key][stat_param][period] -= [stat_value_by_period, value_before].min if value_before
              end
            end if stat[global_name][stat_type][with_filtr_key]
          end
        end
      end
    end
    
    def deduct_without_filtr_daily_from_stat_type(stat, global_name, category_ids_key, stat_type, used_values)
      without_filtr_key = stat[global_name][stat_type].keys[0]
      stat[global_name][stat_type][without_filtr_key].keys.each do |stat_param|
        used_values.each_with_index do |used_share_by_period, period|
          process_stat_param_value(stat[global_name]["without_filtr"][category_ids_key][stat_param]) do |key, stat_param_value|
            next if stat_param_value[period].blank?
            stat_value_by_period = (stat_param_value[period] || 0.0) * used_share_by_period
            if key
              value_before = stat[global_name][stat_type][without_filtr_key][stat_param][key][period]
              stat[global_name][stat_type][without_filtr_key][stat_param][key][period] -= [stat_value_by_period, value_before].min if value_before
            else
              value_before = stat[global_name][stat_type][without_filtr_key][stat_param][period]
              stat[global_name][stat_type][without_filtr_key][stat_param][period] -= [stat_value_by_period, value_before].min if value_before
            end
          end if stat[global_name]["without_filtr"][category_ids_key]
        end
      end if stat[global_name][stat_type][without_filtr_key]
    end

    def deduct_with_filtr_daily_from_stat_type(stat, global_name, category_ids_key, stat_type, used_values)
      without_filtr_key = stat_type == "with_filtr" ? category_ids_key : stat[global_name][stat_type].keys[0]
      stat[global_name][stat_type][without_filtr_key].keys.each do |stat_param|
        used_values.each_with_index do |used_share_by_period, period|
          process_stat_param_value(stat[global_name]["with_filtr"][category_ids_key][stat_param]) do |key, stat_param_value|
            next if stat_param_value[period].blank?
            stat_value_by_period = (stat_param_value[period] || 0.0) * used_share_by_period
            if key
              value_before = stat[global_name][stat_type][without_filtr_key][stat_param][key][period]
              stat[global_name][stat_type][without_filtr_key][stat_param][key][period] -= [stat_value_by_period, value_before].min if value_before
            else
              value_before = stat[global_name][stat_type][without_filtr_key][stat_param][period]
              stat[global_name][stat_type][without_filtr_key][stat_param][period] -= [stat_value_by_period, value_before].min if value_before
            end
          end if stat[global_name]["with_filtr"][category_ids_key]
        end
      end if stat[global_name][stat_type][without_filtr_key]
    end


    def stat_params_from_global_daily(stat, stat_param_names, service_categories)
      stat_params = {}; used_global_categories = {}
#      stat_param_names.each{|stat_param_name| stat_params[stat_param_name] = []}
      (0..31).each do |period|        
        iterate(stat, service_categories) do |filtr_type, service_category, global_name, category_ids_key|
          if filtr_type
            used_global_categories[global_name] ||= {}
            used_global_categories[global_name][filtr_type] ||= {}
            used_global_categories[global_name][filtr_type][category_ids_key] = true
          end
        end if period == 0

        iterate(stat, service_categories) do |filtr_type, service_category, global_name, category_ids_key|
          if filtr_type
            stat_param_names.each do |stat_param_name|
              process_stat_param_value(stat[global_name][filtr_type][category_ids_key][stat_param_name]) do |key, stat_param_value|
                next if !stat_param_value[period]
                if key
                  stat_params[stat_param_name] = {} if !stat_params[stat_param_name].is_a?(Hash)
                  stat_params[stat_param_name][key] ||= []
                  stat_params[stat_param_name][key][period] ||= 0.0 
                  stat_params[stat_param_name][key][period] += stat_param_value[period]
                else
                  stat_params[stat_param_name] ||= []
                  stat_params[stat_param_name][period] ||= 0.0 
                  stat_params[stat_param_name][period] += stat_param_value[period]
                end
              end
            end 
          end
        end
      end
      raise(StandardError, [stat_params, used_global_categories]) if false
      [stat_params, used_global_categories]
    end
    
    def stat_params_from_global(stat, stat_param_names, service_categories)
      period = 0
      stat_params = {}; used_global_categories = {}
#      stat_param_names.each{|stat_param_name| stat_params[stat_param_name] = 0.0}
      iterate(stat, service_categories) do |filtr_type, service_category, global_name, category_ids_key|
        if filtr_type
          used_global_categories[global_name] ||= {}
          used_global_categories[global_name][filtr_type] ||= {}
          used_global_categories[global_name][filtr_type][category_ids_key] = true

          stat_param_names.each do |stat_param_name|
            process_stat_param_value(stat[global_name][filtr_type][category_ids_key][stat_param_name]) do |key, stat_param_value|
              next if !stat_param_value[period]
              if key
                stat_params[stat_param_name] = {} if !stat_params[stat_param_name].is_a?(Hash)
                stat_params[stat_param_name][key] ||= 0.0
                stat_params[stat_param_name][key] += stat_param_value[period]
              else
                stat_params[stat_param_name] ||= 0.0 
                stat_params[stat_param_name] += stat_param_value[period]
              end
            end
          end 
        end
      end
      raise(StandardError, [stat_params, used_global_categories]) if false
      [stat_params, used_global_categories]
    end
    
    def clean_all(stat, used_global_categories)
      used_global_categories.each do |global_name, used_global_category|
        if used_global_category["without_filtr"].blank?
          used_global_category["with_filtr"].each do |category_ids_key, used_value|
            deduct_all_with_filtr_from_stat_type(stat, global_name, category_ids_key, "without_filtr")
            deduct_all_with_filtr_from_stat_type(stat, global_name, category_ids_key, "aggregated")
            stat[global_name]["with_filtr"].extract!(category_ids_key)
          end  
          if stat[global_name]["with_filtr"].blank? and 
              (stat[global_name]["without_filtr"].blank? or stat[global_name]["without_filtr"].first[1].try(:[], "call_id_count").try(:[], 0) == 0)
            raise(StandardError, ["error in clean_all funciton", global_name, stat[global_name]] ) if false and !check_aggregate_for_zero(stat, global_name)
            stat.extract!(global_name)
          end                
        else
          stat.extract!(global_name)
        end
      end
    end
    
    def deduct_all_with_filtr_from_stat_type(stat, global_name, category_ids_key, stat_type)
      without_filtr_key = stat[global_name][stat_type].keys[0]
      stat[global_name][stat_type][without_filtr_key].keys.each do |stat_param|
        process_stat_param_value(stat[global_name]["with_filtr"][category_ids_key][stat_param]) do |key, stat_param_value|
          stat_param_value.each_with_index do |stat_value_by_period, period|
            next if stat_value_by_period.blank?
            if key
              value_before = stat[global_name][stat_type][without_filtr_key][stat_param][key][period]
              stat[global_name][stat_type][without_filtr_key][stat_param][key][period] -= [stat_value_by_period, value_before].min if value_before
            else
              value_before = stat[global_name][stat_type][without_filtr_key][stat_param][period]
              stat[global_name][stat_type][without_filtr_key][stat_param][period] -= [stat_value_by_period, value_before].min if value_before
            end
          end
        end
      end if stat[global_name][stat_type][without_filtr_key]
    end
    
    def iterate(stat, service_categories)
      service_categories.each do |service_category|
        next if service_category['uniq_service_category'].blank?
        global_name = service_category['uniq_service_category']
        next if stat[global_name].blank?
        category_ids_keys = stat[global_name]["with_filtr"].keys.map{|category_ids_with_filtr| category_ids_with_filtr if category_ids_with_filtr.include?(service_category['id']) }.compact

        raise(StandardError, [
          
        ]) if false and service_category['id'] == 298664
        
        if !category_ids_keys.blank?
          category_ids_keys.map{|category_ids_key| yield ["with_filtr", service_category, global_name, category_ids_key] }          
        else
          category_ids_key = stat[global_name]["without_filtr"].keys[0] if (stat[global_name]["without_filtr"].keys[0] || []).include?(service_category['id'])
          if category_ids_key
            yield ["without_filtr", service_category, global_name, category_ids_key]
          else
            yield [nil, service_category, global_name, nil]
          end 
        end
      end
    end
    
    def check_aggregate_for_zero(stat, global_name)
      stat[global_name]["aggregated"][:[]].each do |stat_param_name, stat_param_value|
        process_stat_param_value(stat_param_value) do |key, value|
          value.each do |stat_param_value_by_period|
            return false if stat_param_value_by_period and stat_param_value_by_period > 0.0
          end if value
        end
      end
      true
    end

    def process_stat_param_value(stat_param_value)
      if stat_param_value.is_a?(Hash)
        stat_param_value.each do |k,v|
          yield [k, v]
        end
      else
        yield [nil, stat_param_value]
      end
    end

#  end

#  def included(base)
#    base.extend(ClassMethods)
#  end
  end
end
