module Optimization
  class FinalTarifResultPreparator
  #  attr_reader :if_save_history, :history
  #  attr_reader :indexed_tarif_set, :indexed_tarif_set_ids, :sorted_parts
  
    def initialize(options = {})
    end
    
     def save(operator_id, tarif_id, run_id, service_sets_array, services_array, categories_array, agregates_array)
      result_tarif_id = Result::Tarif.where(:run_id => run_id, :tarif_id => tarif_id).first_or_create()[:id]
      Result::ServiceSet.where(:run_id => run_id, :tarif_id => tarif_id).delete_all
      Result::Service.where(:run_id => run_id, :tarif_id => tarif_id).delete_all
      Result::ServiceCategory.where(:run_id => run_id, :tarif_id => tarif_id).delete_all
      Result::Agregate.where(:run_id => run_id, :tarif_id => tarif_id).delete_all
  
      Result::ServiceSet.bulk_insert values: service_sets_array
      Result::Service.bulk_insert values: services_array
      Result::ServiceCategory.bulk_insert values: categories_array
      Result::Agregate.bulk_insert values: agregates_array
    end
  
    def prepare_service_sets(operator_id, tarif_id, run_id, service_set_id, stat, preloaded_data)
      preprocess_stat(stat)
      service_set_result = prepare_service_set_result(operator_id, tarif_id, run_id, service_set_id, stat)
      service_result = prepare_service_result(operator_id, tarif_id, run_id, service_set_id, stat)
      category_result, agregate_result = prepare_service_categories_result(operator_id, tarif_id, run_id, service_set_id, stat, preloaded_data)
      transform_to_arrays(service_set_result, service_result, category_result, agregate_result)
    end
    
    def transform_to_arrays(service_set_result, service_result, category_result, agregate_result)
      service_sets_array = []; services_array = []; categories_array = []; agregates_array = [];
      
      service_sets_array << service_set_result
      service_result.each do |service_id, result|
        services_array << service_result[service_id]      
        category_result[service_id].each {|sc_name, sc_resutl| categories_array << category_result[service_id][sc_name] } if category_result[service_id]
      end if service_result
      agregate_result.each{|sc_name, result| agregates_array << agregate_result[sc_name] }      
      
      [service_sets_array, services_array, categories_array, agregates_array]
    end
    
    def preprocess_stat(stat)
      iterate_stat(stat) do |part, tarif_set_by_part_id, service_id, calculation_order, service_category_group_id, stat_by_service_category_group|
        raise(StandardError, [
          stat_by_service_category_group[:stat_params]
        ]) if false and service_id == 441 and !['onetime', 'periodic'].include?(part)
        (stat_by_service_category_group[:stat_params].keys & ['day_sum_volume', 'day_count_volume']).each do |stat_key|
          new_stat_key = case stat_key
          when 'day_sum_volume'; 'sum_volume'
          when 'day_count_volume'; 'count_volume'
          end
          stat[part][tarif_set_by_part_id][service_id][calculation_order][service_category_group_id][:stat_params][new_stat_key] = 
            stat_by_service_category_group[:stat_params][stat_key][1..-1].compact.sum
          stat[part][tarif_set_by_part_id][service_id][calculation_order][service_category_group_id][:stat_params].extract!(stat_key)
        end
        
        if stat_by_service_category_group[:stat_params]['call_id_count'].is_a?(Array)
          stat[part][tarif_set_by_part_id][service_id][calculation_order][service_category_group_id][:stat_params]['call_id_count'] = 
            stat_by_service_category_group[:stat_params]['call_id_count'][1..-1].compact.sum
        end
      end
    end
    
    def prepare_service_set_result(operator_id, tarif_id, run_id, service_set_id, stat)
      service_ids = [] 
      stat.each{|part, stat_by_part| stat_by_part.each{|final_tarif_set_by_part_name, r| service_ids += final_tarif_set_by_part_name.split("_").map(&:to_i)} }
      service_ids.uniq!
      service_ids_without_common_services = service_set_id.split("_").map(&:to_i).uniq
      common_services = service_ids - service_ids_without_common_services
      tarif_options = service_ids_without_common_services - [tarif_id]
      service_set_name = (common_services + [tarif_id] + tarif_options).join('_'.freeze)
      
      service_set_result = {
        'run_id'.freeze => run_id, 'operator_id'.freeze => operator_id, 'tarif_id'.freeze => tarif_id, 'service_set_id'.freeze => service_set_id,
        'service_ids'.freeze => service_ids, 'identical_services'.freeze => [], 'common_services'.freeze => common_services, 'tarif_options'.freeze => tarif_options,
        'price'.freeze => 0.0, 'call_id_count'.freeze => 0, 'categ_ids'.freeze => []}
  
      iterate_stat(stat) do |part, tarif_set_by_part_id, service_id, calculation_order, service_category_group_id, stat_by_service_category_group|      
        service_set_result = process_stat_keys(stat_by_service_category_group[:stat_params], service_set_result)
      end
      raise(StandardError, service_set_result) if false 
      service_set_result
    end
  
    def prepare_service_result(operator_id, tarif_id, run_id, service_set_id, stat)
      service_result = {}
      stat_keys_to_calculate = ['call_id_count', 'sum_duration_minute', 'count_volume', 'sum_volume', 'price', 'categ_ids']
  
      iterate_stat(stat) do |part, tarif_set_by_part_id, service_id, calculation_order, service_category_group_id, stat_by_service_category_group|      
        service_result[service_id] ||= {
          'run_id'.freeze => run_id, 'tarif_id'.freeze =>  tarif_id, 'service_set_id'.freeze => service_set_id, 'service_id'.freeze => service_id,
          'price'.freeze => 0.0, 'call_id_count'.freeze => 0, 'categ_ids'.freeze => []}
        service_result[service_id] = service_set_result = process_stat_keys(stat_by_service_category_group[:stat_params], service_result[service_id])
      end
      raise(StandardError, service_result) if false
      service_result
    end
    
    def prepare_service_categories_result(operator_id, tarif_id, run_id, service_set_id, stat, preloaded_data)
      category_result = {}; agregate_result = {}
      stat_keys_to_calculate = ['call_id_count', 'sum_duration_minute', 'count_volume', 'sum_volume', 'price', 'categ_ids']
  
      iterate_stat(stat) do |part, tarif_set_by_part_id, service_id, calculation_order, service_category_group_id, stat_by_service_category_group|    
        category_details = tarif_detail_results_description(preloaded_data, service_category_group_id, stat_by_service_category_group)
        all_categories = []
        ['service_category_rouming_name'.freeze, 'service_category_calls_name'.freeze, 'service_category_geo_name'.freeze, 'service_category_partner_type_name'.freeze, 
          'uniq_service_category'.freeze, 'service_category_one_time_id'.freeze, 'service_category_periodic_id'.freeze, 'filtr'.freeze].collect do |category|
            all_categories += category_details[category].map(&:to_s)
         end         
        sc_name = all_categories.join('_'.freeze)
  
        category_result[service_id] ||= {};   
        category_result[service_id][sc_name] ||= {
          'run_id'.freeze => run_id, 'tarif_id'.freeze =>  tarif_id, 'service_set_id'.freeze => service_set_id, 'service_id'.freeze => service_id,
          'price'.freeze => 0.0, 'call_id_count'.freeze => 0, 'categ_ids'.freeze => [], 'uniq_service_categories'.freeze => []}
  
        agregate_result[sc_name] ||= {
          'run_id'.freeze => run_id, 'tarif_id'.freeze =>  tarif_id, 'service_set_id'.freeze => service_set_id,
          'price'.freeze => 0.0, 'call_id_count'.freeze => 0, 'categ_ids'.freeze => [], 'uniq_service_categories'.freeze => []}
  
        category_result[service_id][sc_name] = process_stat_keys(stat_by_service_category_group[:stat_params], category_result[service_id][sc_name])
        agregate_result[sc_name] = process_stat_keys(stat_by_service_category_group[:stat_params], agregate_result[sc_name])
  
        next if category_result[service_id][sc_name]['service_category_name'.freeze]
        
        category_result[service_id][sc_name]['service_category_name'.freeze] = sc_name
        agregate_result[sc_name]['service_category_name'.freeze] = sc_name
  
        category_result[service_id][sc_name]['partner_details'.freeze] = []
        agregate_result[sc_name]['partner_details'.freeze] = []
  
        category_result[service_id][sc_name]['categ_ids'.freeze] += (category_details['categ_ids'.freeze] || []).uniq
        category_result[service_id][sc_name]['uniq_service_categories'.freeze] += (category_details['uniq_service_category'.freeze] || []).uniq
        category_result[service_id][sc_name]['one_time_ids'.freeze] = category_details['service_category_one_time_id'.freeze]
        category_result[service_id][sc_name]['periodic_ids'.freeze] = category_details['service_category_periodic_id'.freeze]
        category_result[service_id][sc_name]['fix_ids'.freeze] = category_details['service_category_one_time_id'.freeze] + category_details['service_category_periodic_id'.freeze]
  
        category_result[service_id][sc_name]['rouming_names'.freeze] = category_details['service_category_rouming_name'.freeze]
        category_result[service_id][sc_name]['geo_names'.freeze] = category_details['service_category_geo_name'.freeze]
        category_result[service_id][sc_name]['partner_names'.freeze] = category_details['service_category_partner_type_name'.freeze]
        category_result[service_id][sc_name]['calls_names'.freeze] = category_details['service_category_calls_name'.freeze]
        category_result[service_id][sc_name]['one_time_names'.freeze] = category_details['service_category_one_time_name'.freeze]
        category_result[service_id][sc_name]['periodic_names'.freeze] = category_details['service_category_periodic_name'.freeze]
        category_result[service_id][sc_name]['fix_names'.freeze] = category_details['service_category_one_time_name'.freeze] + category_details['service_category_periodic_name'.freeze]
  
        category_result[service_id][sc_name]['rouming_details'.freeze] = category_details['service_category_rouming_id_details'.freeze]
        category_result[service_id][sc_name]['geo_details'.freeze] = category_details['service_category_geo_id_details'.freeze]
  
  
        agregate_result[sc_name]['categ_ids'.freeze] += (category_details['categ_ids'] || []).uniq
        agregate_result[sc_name]['uniq_service_categories'.freeze] += (category_details['uniq_service_categories'] || []).uniq
        agregate_result[sc_name]['one_time_ids'.freeze] = category_details['service_category_one_time_id'.freeze]
        agregate_result[sc_name]['periodic_ids'.freeze] = category_details['service_category_periodic_id'.freeze]
        agregate_result[sc_name]['fix_ids'.freeze] = category_details['service_category_one_time_id'.freeze] + category_details['service_category_periodic_id'.freeze]
  
        agregate_result[sc_name]['rouming_names'.freeze] = category_details['service_category_rouming_name'.freeze]
        agregate_result[sc_name]['geo_names'.freeze] = category_details['service_category_geo_name'.freeze]
        agregate_result[sc_name]['partner_names'.freeze] = category_details['service_category_partner_type_name'.freeze]
        agregate_result[sc_name]['calls_names'.freeze] = category_details['service_category_calls_name'.freeze]
        agregate_result[sc_name]['one_time_names'.freeze] = category_details['service_category_one_time_name'.freeze]
        agregate_result[sc_name]['periodic_names'.freeze] = category_details['service_category_periodic_name'.freeze]
        agregate_result[sc_name]['fix_names'.freeze] = category_details['service_category_one_time_name'.freeze] + category_details['service_category_periodic_name'.freeze]
  
        agregate_result[sc_name]['rouming_details'.freeze] = category_details['service_category_rouming_id_details'.freeze]
        agregate_result[sc_name]['geo_details'.freeze] = category_details['service_category_geo_id_details'.freeze]
      end
      raise(StandardError, [category_result, agregate_result]) if false   
      [category_result, agregate_result]
    end  
    
    def tarif_detail_results_description(preloaded_data, service_category_group_id, stat_by_service_category_group)
      service_categories = preloaded_data['service_categories']

      service_category_description = {
        'uniq_service_category'.freeze => [],  'filtr'.freeze => [],  
        'service_category_rouming_name'.freeze => [], 'service_category_rouming_id_details'.freeze => [],
        'service_category_geo_name'.freeze => [], 'service_category_geo_id_details'.freeze => [],      
        'service_category_partner_type_name'.freeze => [],'service_category_partner_type_id_details'.freeze => [],
        'service_category_calls_name'.freeze => [], 
        'service_category_one_time_id'.freeze => [], 'service_category_one_time_name'.freeze => [], 
        'service_category_periodic_id'.freeze => [], 'service_category_periodic_name'.freeze => [],
        }
         
      return service_category_description if !service_category_group_id
      
      stat_by_service_category_group[:service_categories].each do |tarif_category|
        detailed_category_names = general_category_names_by_service_category(preloaded_data, tarif_category)
        category_names = category_names_by_service_category(preloaded_data, tarif_category) 
        
        raise(StandardError, [
          tarif_category, detailed_category_names, category_names
        ]) if false
  
        service_category_description['uniq_service_category'.freeze] << tarif_category['uniq_service_category'.freeze]
        service_category_description['filtr'.freeze] << tarif_category['filtr'.freeze]

        if category_names[:rouming]
          service_category_description['service_category_rouming_name'.freeze] << category_names[:rouming]
          service_category_description['service_category_rouming_id_details'.freeze] << (detailed_category_names[:rouming] || '')
        end
  
        if category_names[:geo]
          service_category_description['service_category_geo_name'.freeze] << category_names[:geo]
          service_category_description['service_category_geo_id_details'.freeze] << (detailed_category_names[:geo] || '')
        end
          
        if category_names[:operators]
          service_category_description['service_category_partner_type_name'.freeze] << category_names[:operators] 
          service_category_description['service_category_partner_type_id_details'.freeze] << (detailed_category_names[:operators] || '')
        end
  
        service_category_description['service_category_calls_name'.freeze] << category_names[:calls] if category_names[:calls]
  
        service_category_description['service_category_one_time_id'.freeze] << tarif_category['service_category_one_time_id'.freeze]
        service_category_description['service_category_one_time_name'.freeze] << service_categories[tarif_category['service_category_one_time_id'.freeze].to_s]['name'.freeze] if 
          tarif_category['service_category_one_time_id'.freeze] and service_categories[tarif_category['service_category_one_time_id'.freeze].to_s]
  
        service_category_description['service_category_periodic_id'.freeze] << tarif_category['service_category_periodic_id'.freeze]
        service_category_description['service_category_periodic_name'.freeze] << service_categories[tarif_category['service_category_periodic_id'.freeze].to_s]['name'.freeze] if 
          tarif_category['service_category_periodic_id'.freeze] and service_categories[tarif_category['service_category_periodic_id'.freeze].to_s]
      end if stat_by_service_category_group[:service_categories]
      
      service_category_description.each do |key, value|
        service_category_description[key].uniq! if service_category_description[key].is_a?(Array)
      end
    end
    
    def category_names_by_service_category(preloaded_data, tarif_category)
      global_categories = Optimization::Global::Base::CategoryHelper.global_categories_from_uniq_category(tarif_category)

      if global_categories[3]
        global_categories[3][0] = global_categories[3][0] == "in" ? "на" : "кроме" 
        global_categories[3][1] = global_categories[3][1].map{|operator_id| (preloaded_data['general_categories'][operator_id] || preloaded_data['general_categories'][operator_id.to_s]).try(:[], 'name')}
        global_categories[3] = global_categories[3][1].size == 1 ? "#{global_categories[3][0]} своего оператора" : "#{global_categories[3][0]} #{global_categories[3][1].join(', ')}"        
      end
      
      global_categories = global_categories.map{|category_name| Optimization::Global::Base::Dictionary.tr(category_name)}
  
      {
        :calls => [
          preloaded_data['service_categories'][tarif_category["service_category_one_time_id"]].try(:[], 'name'), 
          preloaded_data['service_categories'][tarif_category["service_category_periodic_id"]].try(:[], 'name'), 
          global_categories[1]
        ].compact[0],
        :rouming => global_categories[0], :geo => global_categories[2], :operators => global_categories[3],
      }
    end

    def general_category_names_by_service_category(preloaded_data, tarif_category)
      category_ids = Optimization::Global::Base::CategoryHelper.category_ids_from_filtr(tarif_category["filtr"])

      result = {:geo => [], :rouming => [], :operators => []}
      category_ids.each do |key, category_ids_by_key|
        category_ids_by_key.compact.uniq.map{|id| result[key] << (preloaded_data['general_categories'][id].try(:[], 'name') || preloaded_data['general_categories'][id.to_s].try(:[], 'name')) }
        result[key] = result[key].join(', ')
      end
      
      result
    end
  
    def process_stat_keys(stat_by_key, initial_value = {})
      stat_keys_to_calculate = ['call_id_count', 'sum_duration_minute', 'count_volume', 'sum_volume', 'price', 'categ_ids']
      stat_keys_to_calculate.each do |stat_key|
        if stat_by_key[stat_key].is_a?(Array)
          initial_value[stat_key] ||= []
          
          raise(StandardError, [stat_key, initial_value[stat_key], stat_by_key ]) if initial_value[stat_key].is_a?(Float)
          
          initial_value[stat_key] += (stat_by_key[stat_key].uniq - initial_value[stat_key])
        else
          initial_value[stat_key] ||= 0
          initial_value[stat_key] += (stat_by_key[stat_key] || 0).round(2)
        end
      end if stat_by_key
      initial_value
    end
    
    def iterate_stat(stat)
      stat.each do |part, stat_by_part|
        stat_by_part.each do |tarif_set_by_part_id, stat_by_service_set|
          stat_by_service_set.each do |service_id, stat_by_service|
            stat_by_service.each do |calculation_order, stat_calculation_order|
              stat_calculation_order.each do |service_category_group_id, stat_by_service_category_group|
                yield [part, tarif_set_by_part_id, service_id, calculation_order, service_category_group_id, stat_by_service_category_group]
              end
            end
          end
        end
      end
    end
  
  end  
end
