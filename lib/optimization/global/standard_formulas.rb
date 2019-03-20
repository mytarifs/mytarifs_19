#require_dependency 'Optimization::Global::StandardFormulasHelper'
module Optimization::Global
  module StandardFormulas
    include Optimization::Global::StandardFormulasHelper
  #  extend Optimization::Global::StandardFormulasHelper
    
  #  module ClassMethods
  
      def test
    #      tarif_class_id with 61, 70, 71 standard_function [673, 110, 803, 471, 624, 288, 553]
    #      ["count_volume"], ["sum_call_by_minutes", "sum_duration", "sum_duration_minute"], ["day_sum_volume", "sum_volume"]
    
        calls = Customer::Call.where(:call_run_id => 553)
        accounting_period = calls.first.description['accounting_period']
        calls = calls.where("description->>'accounting_period' = '#{accounting_period}'")
        calls = Customer::Call.where(:call_run_id => 553)            
        formula_id = Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice
    
        fields = [
          "service_category_groups.id", "service_category_groups.tarif_class_id", "formula, price_formulas.standard_formula_id", "price_formulas.formula->'params' as params"
          ]
        service_group = Service::CategoryGroup.joins(:service_category_tarif_classes, price_lists: :formulas).
          where(:price_formulas => {:standard_formula_id => formula_id}).
    #        where.not("price_formulas.formula->>'window_over' = 'day'").
    #        where(:service_category_tarif_classes => {:id => 38711}).
          where(:service_category_groups => {:tarif_class_id => 441}).
    #        where.not(:service_category_tarif_classes => {:filtr => nil}).
    #        where.not(:service_category_tarif_classes => {:uniq_service_category => ["abroad_countries/sms_in"]}).
          select(fields)[0]
        
        service_id = service_group.tarif_class_id
        params = service_group.formula['params']
        window_over = service_group.formula['window_over']
        
        raise(StandardError, [service_id, params, window_over, formula_name_from_formula_id(formula_id)]) if false
        
        service_categories = if service_group.price_lists.first.formulas.first.standard_formula.formula["tarif_condition"]
          Service::CategoryTarifClass.joins(:as_standard_category_group).
          where(:service_category_groups => {:tarif_class_id => service_id}).all
        else
          Service::CategoryTarifClass.where(:as_standard_category_group_id => service_group.id).all
        end
        service_category_ids = service_categories.map(&:id)
    
        @global_stat = Optimization::Global::Stat.new.all_global_categories_stat(calls, [service_id])
        @current_stat = @global_stat.deep_dup# Marshal.load(Marshal.dump(@global_stat))#@global_stat.clone
        global_name = service_categories.first.uniq_service_category
        global_names = service_categories.map(&:uniq_service_category)
        tarif_set_stat = {}
        result_of_function = call_by_id(formula_id, @current_stat, tarif_set_stat, params, service_categories, window_over)
    #      @current_stat.extract!(global_name)
        stat_to_show_after = @current_stat.slice(*global_names)
        [service_id, service_category_ids, global_names, params, window_over, result_of_function, @global_stat.slice(*global_names), "###################", stat_to_show_after]      
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
  
      def price_by_item(stat, tarif_set_stat, params, service_categories, window_over = nil)
        result = if !tarif_set_stat[:depended_on_services].blank? and tarif_set_stat[:current_service_group_dependent_on]
          new_onetime_services_by_month = tarif_set_stat_by_month(tarif_set_stat, :calculated_onetime_services_by_month)
          raise(StandardError, [
            new_onetime_services_by_month, params['price']
          ]) if false and tarif_set_stat[:prev_service_ids] == [495, 493, 477, 470]
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
        raise(StandardError, [
          used_global_categories, "######",
          stat, "#######",
          params, "###########",
          service_categories.map(&:id), "##########",
          params['price'], stat_params['sum_duration_minute']
        ]) if false
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
        raise(StandardError, [
          stat, "#############", stat_before, "###############", params, service_categories.map(&:id), stat_params
        ]) if false and params['max_duration_minute'] == 30.0 #and stat_before.keys.include?()
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
        
        raise(StandardError, [
          used_global_categories, 
          "#############", stat_params, stat
        ]) if false
        
        clean_all(stat, used_global_categories)
        
        result = sum_duration_minute_0 * price_0 + sum_duration_minute_1 * price_1 + params['duration_minute_1'] * count_duration_minute_1 * (price_0 - price_1)
        [result, stat_params]
      end
  
      def three_step_price_duration_minute(stat, tarif_set_stat, params, service_categories, window_over = nil) 
        params_to_calculate = ['sum_duration_minute', 'sum_call_by_minutes', 'count_call_by_minutes', 'call_id_count']
        stat_params, used_global_categories = stat_params_from_global(stat, params_to_calculate, service_categories)      
        return [0.0, {}] if used_global_categories.blank?
  
        global_names = used_global_categories.keys
        raise(StandardError, [@global_stat.slice(*global_names),
        "##############", stat.slice(*global_names), 
        "##############", used_global_categories, "###############", params, stat_params,]) if false
  
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
