#require_dependency 'Optimization::Global::StandardFormulasHelper'
module Optimizator::Global
  module StandardFormulas
    include Optimizator::Global::StandardFormulasHelper
      def test
      end
      
      def price_by_month(stat, tarif_set_stat, params, service_categories, window_over = nil)
        result = if !tarif_set_stat[:depended_on_services].blank? and tarif_set_stat[:current_service_group_dependent_on]
          new_onetime_services_by_month = tarif_set_stat_by_month(tarif_set_stat, :calculated_periodic_services_by_month)
          !new_onetime_services_by_month.blank? ? params['price'] : 0.0
        else
          params['price']
        end
        [result, {}]
      end
  
      def price_by_day(stat, tarif_set_stat, params, service_categories, window_over = nil)
        result = if !tarif_set_stat[:depended_on_services].blank? and tarif_set_stat[:current_service_group_dependent_on]
          new_onetime_services_by_month = tarif_set_stat_by_month(tarif_set_stat, :calculated_periodic_services_by_month)
          !new_onetime_services_by_month.blank? ? params['price'] * 30.0 : 0.0
        else
          params['price'] * 30.0
        end
        [result, {}]
      end
  
      def price_by_item(stat, tarif_set_stat, params, service_categories, window_over = nil)
        result = if !tarif_set_stat[:depended_on_services].blank? and tarif_set_stat[:current_service_group_dependent_on]
          new_onetime_services_by_month = tarif_set_stat_by_month(tarif_set_stat, :calculated_onetime_services_by_month)
          !new_onetime_services_by_month.blank? ? params['price'] : 0.0
        else
          params['price']
        end
        [result, {}]
      end
  
      def price_by_sum_duration_second(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = stat_params_from_global(stat, ['sum_duration', 'call_id_count'], service_categories)      
        return [0.0, {}] if used_global_categories.blank?
        clean_all(stat, used_global_categories)
        stat_params['sum_duration_minute'] = stat_params['sum_duration'] / 60.0
        result = params['price'] * stat_params['sum_duration']
        [result, stat_params]
      end
      
      def price_by_count_volume_item(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = stat_params_from_global(stat, ['count_volume', 'call_id_count'], service_categories)      
        return [0.0, {}] if used_global_categories.blank?
        clean_all(stat, used_global_categories)
        result = params['price'] * stat_params['count_volume']
        [result, stat_params]
      end
      
      def price_by_sum_volume_m_byte(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = stat_params_from_global(stat, ['sum_volume', 'call_id_count'], service_categories)      
        return [0.0, {}] if used_global_categories.blank?
        clean_all(stat, used_global_categories)
        result = params['price'] * stat_params['sum_volume']
        [result, stat_params]
      end
      
      def price_by_sum_duration(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = stat_params_from_global(stat, ['sum_duration_minute', 'call_id_count'], service_categories)      
        return [0.0, {}] if used_global_categories.blank?
        clean_all(stat, used_global_categories)
        result = params['price'] * stat_params['sum_duration_minute']
        [result, stat_params]
      end
      
      def fixed_price_if_used_in_one_day_duration(stat, tarif_set_stat, params, service_categories, window_over = nil)  
        new_non_zero_days = days_with_non_zero_call_id_count(stat, service_categories).compact.uniq
        new_non_zero_days = tarif_set_stat_by_day(tarif_set_stat, :calculated_periodic_services_by_day, new_non_zero_days) if !tarif_set_stat[:depended_on_services].blank?
        result = params['price'] * new_non_zero_days.size
        [result, {}]
      end
      
      def fixed_price_if_used_in_one_day_volume(stat, tarif_set_stat, params, service_categories, window_over = nil)       
        new_non_zero_days = days_with_non_zero_call_id_count(stat, service_categories).compact.uniq
        new_non_zero_days = tarif_set_stat_by_day(tarif_set_stat, :calculated_periodic_services_by_day, new_non_zero_days) if !tarif_set_stat[:depended_on_services].blank?
        result = params['price'] * new_non_zero_days.size
        [result, {}]
      end
      
      def fixed_price_if_used_in_one_day_any(stat, tarif_set_stat, params, service_categories, window_over = nil)       
        new_non_zero_days = days_with_non_zero_call_id_count(stat, service_categories).compact.uniq
        new_non_zero_days = tarif_set_stat_by_day(tarif_set_stat, :calculated_periodic_services_by_day, new_non_zero_days) if !tarif_set_stat[:depended_on_services].blank?
        result = params['price'] * new_non_zero_days.size
        [result, {}]
      end
      
      def price_by_month_if_used(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        result = check_if_call_id_count_is_non_zero(stat, service_categories, 0) ? params['price'] : 0.0
        [result, {}]
      end
      
      def price_by_item_if_used(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        result = check_if_call_id_count_is_non_zero(stat, service_categories, 0) ? params['price'] : 0.0
        [result, {}]
      end
      
      def max_duration_minute_for_fixed_price(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = if window_over == 'day'
  #        stat_params_from_global_with_day_limit_average(stat, ['sum_duration_minute', 'call_id_count'], service_categories, 'sum_duration_minute', params['max_duration_minute'])
          stat_params_from_global_with_day_limit(stat, ['sum_duration_minute', 'call_id_count'], service_categories, 'sum_duration_minute', params['max_duration_minute'])
        else
          stat_params_from_global_with_month_limit(stat, ['sum_duration_minute', 'call_id_count'], service_categories, 'sum_duration_minute', params['max_duration_minute'])
        end
        return [0.0, {}] if used_global_categories.blank?
        days_in_month = 30.0
        stat_before = stat.deep_dup
        clean_daily(stat, used_global_categories)
        result = window_over == 'day' ? params['price'] * days_in_month : params['price']
        [result, stat_params]
      end
  
      def max_count_volume_for_fixed_price(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = if window_over == 'day'
          stat_params_from_global_with_day_limit(stat, ['count_volume', 'call_id_count'], service_categories, 'count_volume', params['max_count_volume'])
        else
          stat_params_from_global_with_month_limit(stat, ['count_volume', 'call_id_count'], service_categories, 'count_volume', params['max_count_volume'])
        end
        return [0.0, {}] if used_global_categories.blank?
        days_in_month = 30.0
        clean_daily(stat, used_global_categories)
        result = window_over == 'day' ? params['price'] * days_in_month : params['price']
        [result, stat_params]
      end
      
      def max_sum_volume_m_byte_for_fixed_price(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = if window_over == 'day'
          stat_params_from_global_with_day_limit(stat, ['sum_volume', 'call_id_count'], service_categories, 'sum_volume', params['max_sum_volume'])
        else
          stat_params_from_global_with_month_limit(stat, ['sum_volume', 'call_id_count'], service_categories, 'sum_volume', params['max_sum_volume'])
        end
        return [0.0, {}] if used_global_categories.blank?
        clean_daily(stat, used_global_categories)
        days_in_month = 30.0
        result = window_over == 'day' ? params['price'] * days_in_month : params['price']
        [result, stat_params]
      end
  
      def max_duration_minute_for_fixed_price_if_used(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = if window_over == 'day'
          stat_params_from_global_with_day_limit(stat, ['sum_duration_minute', 'call_id_count'], service_categories, 'sum_duration_minute', params['max_duration_minute'])
        else
          stat_params_from_global_with_month_limit(stat, ['sum_duration_minute', 'call_id_count'], service_categories, 'sum_duration_minute', params['max_duration_minute'])
        end
        return [0.0, {}] if used_global_categories.blank?
        days_used_in_month = days_with_non_zero_call_id_count(stat, service_categories).compact.uniq.size
        clean_daily(stat, used_global_categories)
        result = window_over == 'day' ? params['price'] * days_used_in_month : params['price']
        [result, stat_params]
      end
      
      def max_count_volume_for_fixed_price_if_used(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = if window_over == 'day'
          stat_params_from_global_with_day_limit(stat, ['count_volume', 'call_id_count'], service_categories, 'count_volume', params['max_count_volume'])
        else
          stat_params_from_global_with_month_limit(stat, ['count_volume', 'call_id_count'], service_categories, 'count_volume', params['max_count_volume'])
        end
        return [0.0, {}] if used_global_categories.blank?
        days_used_in_month = days_with_non_zero_call_id_count(stat, service_categories).compact.uniq.size
        clean_daily(stat, used_global_categories)
        result = window_over == 'day' ? params['price'] * days_used_in_month : params['price']
        [result, stat_params]
      end
      
      def max_sum_volume_m_byte_for_fixed_price_if_used(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = if window_over == 'day'
          stat_params_from_global_with_day_limit(stat, ['sum_volume', 'call_id_count'], service_categories, 'sum_volume', params['max_sum_volume'])
        else
          stat_params_from_global_with_month_limit(stat, ['sum_volume', 'call_id_count'], service_categories, 'sum_volume', params['max_sum_volume'])
        end
        return [0.0, {}] if used_global_categories.blank?
        days_used_in_month = days_with_non_zero_call_id_count(stat, service_categories).compact.uniq.size
        clean_daily(stat, used_global_categories)
        result = window_over == 'day' ? params['price'] * days_used_in_month : params['price']
        [result, stat_params]
      end
  
      def max_duration_minute_for_special_price(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = if window_over == 'day'
          stat_params_from_global_with_day_limit(stat, ['sum_duration_minute', 'call_id_count'], service_categories, 'sum_duration_minute', params['max_duration_minute'])
        else
          stat_params_from_global_with_month_limit(stat, ['sum_duration_minute', 'call_id_count'], service_categories, 'sum_duration_minute', params['max_duration_minute'])
        end
        return [0.0, {}] if used_global_categories.blank?
        clean_daily(stat, used_global_categories)
        result = params['price'] * stat_params['sum_duration_minute']
        [result, stat_params]
      end
      
      def max_count_volume_for_special_price(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = if window_over == 'day'
          stat_params_from_global_with_day_limit(stat, ['count_volume', 'call_id_count'], service_categories, 'count_volume', params['max_count_volume'])
        else
          stat_params_from_global_with_month_limit(stat, tarif_set_stat, ['count_volume', 'call_id_count'], service_categories, 'count_volume', params['max_count_volume'])
        end
        return [0.0, {}] if used_global_categories.blank?
        clean_daily(stat, used_global_categories)
        result = params['price'] * stat_params['count_volume']
        [result, stat_params]
      end
      
      def max_sum_volume_m_byte_for_special_price(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = if window_over == 'day'
          stat_params_from_global_with_day_limit(stat, ['sum_volume', 'call_id_count'], service_categories, 'sum_volume', params['max_sum_volume'])
        else
          stat_params_from_global_with_month_limit(stat, ['sum_volume', 'call_id_count'], service_categories, 'sum_volume', params['max_sum_volume'])
        end
        return [0.0, {}] if used_global_categories.blank?
        clean_daily(stat, used_global_categories)
        result = params['price'] * stat_params['sum_volume']
        [result, stat_params]
      end
      
      def turbobutton_m_byte_for_fixed_price(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = stat_params_from_global(stat, ['sum_volume', 'call_id_count'], service_categories)      
        return [0.0, {}] if used_global_categories.blank?
        count_of_usage = (stat_params['sum_volume'] / params['max_sum_volume']).ceil
        clean_all(stat, used_global_categories)
        result = params['price'] * count_of_usage
        [result, stat_params]
      end
      
      def turbobutton_m_byte_for_fixed_price_day(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = stat_params_from_global_daily(stat, ['day_sum_volume', 'call_id_count'], service_categories)      
        return [0.0, {}] if used_global_categories.blank?
        count_of_usage = stat_params['day_sum_volume'][1..-1].compact.map{|day_sum_volume| (day_sum_volume / params['max_sum_volume']).ceil }.sum
        clean_all(stat, used_global_categories)
        result = params['price'] * count_of_usage
        [result, stat_params]
      end
  
      def max_count_volume_with_multiple_use_month(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = stat_params_from_global(stat, ['count_volume', 'call_id_count'], service_categories)  
        return [0.0, {}] if used_global_categories.blank?
        count_of_usage = (stat_params['count_volume'] / params['max_count_volume']).ceil
        clean_all(stat, used_global_categories)
        result = params['price'] * count_of_usage
        [result, stat_params]
      end
      
      def max_count_volume_with_multiple_use_day(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = stat_params_from_global_daily(stat, ['day_count_volume', 'call_id_count'], service_categories)      
        return [0.0, {}] if used_global_categories.blank?
        count_of_usage = stat_params['day_count_volume'][1..-1].compact.map{|day_sum_volume| (day_sum_volume / params['max_count_volume']).ceil }.sum
        clean_all(stat, used_global_categories)
        result = params['price'] * count_of_usage
        [result, stat_params]
      end
      
      def max_sum_volume_m_byte_with_multiple_use_month(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = stat_params_from_global(stat, ['sum_volume', 'call_id_count'], service_categories)      
        return [0.0, {}] if used_global_categories.blank?
        count_of_usage = (stat_params['sum_volume'] / params['max_sum_volume']).ceil
        clean_all(stat, used_global_categories)
        result = params['price'] * count_of_usage
        [result, stat_params]
      end
      
      def max_sum_volume_m_byte_with_multiple_use_day(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        stat_params, used_global_categories = stat_params_from_global_daily(stat, ['day_sum_volume', 'call_id_count'], service_categories)      
        return [0.0, {}] if used_global_categories.blank?
        count_of_usage = stat_params['day_sum_volume'][1..-1].compact.map{|day_sum_volume| (day_sum_volume / params['max_sum_volume']).ceil }.sum
        clean_all(stat, used_global_categories)
        result = params['price'] * count_of_usage
        [result, stat_params]
      end
  
      def two_step_price_max_duration_minute(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        params_to_calculate = ['sum_duration_minute', 'sum_call_by_minutes', 'count_call_by_minutes', 'call_id_count']
        stat_params, used_global_categories = if window_over == 'day'
          stat_params_from_global_with_day_limit(stat, params_to_calculate, service_categories, 'sum_duration_minute', params['max_duration_minute'])
        else
          stat_params_from_global_with_month_limit(stat, params_to_calculate, service_categories, 'sum_duration_minute', params['max_duration_minute'])
        end
        return [0.0, {}] if used_global_categories.blank?
  
        min_1 = params['duration_minute_1'].to_i.to_s; 
        sum_duration_minute_0 = stat_params['sum_call_by_minutes'][min_1]; sum_duration_minute_1 = stat_params['sum_duration_minute'] - sum_duration_minute_0; 
        count_duration_minute_0 = stat_params['count_call_by_minutes'][min_1]; count_duration_minute_1 = stat_params['call_id_count'] - count_duration_minute_0
        price_0 = params['price_0']; price_1 = params['price_1']
  
        clean_daily(stat, used_global_categories)
  
        result = sum_duration_minute_0 * price_0 + sum_duration_minute_1 * price_1 + params['duration_minute_1'] * count_duration_minute_1 * (price_0 - price_1)
        [result, stat_params]
      end
  
      def two_step_price_duration_minute(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        params_to_calculate = ['sum_duration_minute', 'sum_call_by_minutes', 'count_call_by_minutes', 'call_id_count']
        stat_params, used_global_categories = stat_params_from_global(stat, params_to_calculate, service_categories)      
        return [0.0, {}] if used_global_categories.blank?
        
        min_1 = params['duration_minute_1'].to_i.to_s; 
        sum_duration_minute_0 = stat_params['sum_call_by_minutes'][min_1]; sum_duration_minute_1 = stat_params['sum_duration_minute'] - sum_duration_minute_0; 
        count_duration_minute_0 = stat_params['count_call_by_minutes'][min_1]; count_duration_minute_1 = stat_params['call_id_count'] - count_duration_minute_0
        price_0 = params['price_0']; price_1 = params['price_1']
        
        clean_all(stat, used_global_categories)
        
        result = sum_duration_minute_0 * price_0 + sum_duration_minute_1 * price_1 + params['duration_minute_1'] * count_duration_minute_1 * (price_0 - price_1)
        [result, stat_params]
      end
  
      def three_step_price_duration_minute(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        params_to_calculate = ['sum_duration_minute', 'sum_call_by_minutes', 'count_call_by_minutes', 'call_id_count']
        stat_params, used_global_categories = stat_params_from_global(stat, params_to_calculate, service_categories)      
        return [0.0, {}] if used_global_categories.blank?
  
        global_names = used_global_categories.keys
  
        min_1 = params['duration_minute_1'].to_i.to_s; min_2 = params['duration_minute_2'].to_i.to_s; 
        
        sum_duration_minute_0 = stat_params['sum_call_by_minutes'][min_1] +  
          params['duration_minute_1'] * (stat_params['call_id_count'] - stat_params['count_call_by_minutes'][min_1])
        
        sum_duration_minute_1 = stat_params['sum_call_by_minutes'][min_2] - stat_params['count_call_by_minutes'][min_2] * params['duration_minute_1'] +
          params['duration_minute_2'] * (stat_params['call_id_count'] - stat_params['count_call_by_minutes'][min_1] - stat_params['count_call_by_minutes'][min_2])
          
        sum_duration_minute_2 = stat_params['sum_duration_minute'] - sum_duration_minute_0 - sum_duration_minute_1
        
        price_0 = params['price_0']; price_1 = params['price_1']; price_2 = params['price_2']
  
        clean_all(stat, used_global_categories)
  
        result = sum_duration_minute_0 * price_0 + sum_duration_minute_1 * price_1 + sum_duration_minute_2 * price_2
        [result, stat_params]
      end
  
      def call_by_id(standard_formula_id, stat, tarif_set_stat, params, service_categories, window_over)
        send(formula_name_from_formula_id(standard_formula_id), stat, tarif_set_stat, params, service_categories, window_over)
      end
      
      def formula_name_from_formula_id(formula_id)
        constant_name = standard_formula_const_names.find{|name| Price::StandardFormula::Const.const_get(name) == formula_id}.to_s.underscore.to_sym
      end
      
      def standard_formula_const_names
        return Price::StandardFormula::Const.constants
      end
  
  end
end
