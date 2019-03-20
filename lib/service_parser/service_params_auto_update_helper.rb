module ServiceParser
   
  module ServiceParamsAutoUpdateHelper
    
    def guess_auto_update_params_for_formula(service_category_group)
      return "no service_category_group" if service_category_group.blank?
      return "no service_category_tarif_classes" if service_category_group.service_category_tarif_classes.size == 0
      return "no price_lists" if service_category_group.price_lists.size == 0
      original_formula = service_category_group.price_lists.first.formulas.try(:first)
      return "no price_lists.formulas" if original_formula.blank?
      return "no price_lists.formula params" if original_formula.params.try(:keys).blank?
      result = {}
      first_service_category_tarif_class = service_category_group.service_category_tarif_classes.first

#      result['use_any_service_as_source_of_parsed_results'] = nil
      
      result['formula_param_to_set'] = if service_category_group.service_category_tarif_classes.size == 1
        'price'
      else
        existing_formula_params = original_formula.params.keys
        if existing_formula_params.size == 1
          existing_formula_params[0]
        else
          (existing_formula_params - ['price', 'window_over'])[0]
        end
      end
      
      result['field_value_array_index'] = 0
      
      tarif_class_ids_to_use_as_source_of_parsed_results = service_category_group.service_category_tarif_classes.
        map{|sctc| sctc.conditions.try(:[], 'tarif_set_must_include_tarif_options') || []}.flatten.uniq.map(&:to_i)
        
      tarif_class_ids_that_has_any_category_groups = Service::CategoryGroup.where(:tarif_class_id => tarif_class_ids_to_use_as_source_of_parsed_results).pluck(:tarif_class_id).uniq
      tarif_class_ids_that_has_no_category_groups = tarif_class_ids_to_use_as_source_of_parsed_results - tarif_class_ids_that_has_any_category_groups
      
      result['tarif_class_id_to_use_as_source_of_parsed_results'] = case
      when (!first_service_category_tarif_class.service_category_one_time_id.blank? or !first_service_category_tarif_class.service_category_periodic_id.blank?)
        tarif_class_ids_that_has_no_category_groups[0] || tarif_class_ids_to_use_as_source_of_parsed_results[0] || service_category_group.tarif_class_id
      else
        if service_category_group.service_category_tarif_classes.size == 1
          service_category_group.tarif_class_id
        else
          tarif_class_ids_that_has_any_category_groups[0] || service_category_group.tarif_class_id
        end
      end

      original_global_categories = TarifList.where(:tarif_class_id => result['tarif_class_id_to_use_as_source_of_parsed_results']).
        pluck("distinct(json_object_keys(tarif_lists.features->'current_saved_service_desc'))")
#        map{|original_global_category| ((original_global_category.split(/[^[[:word:]]]+/) || []) - ['']) }
        
      first_matched_original_global_category = if service_category_group.service_category_tarif_classes.size == 1
        case
        when !first_service_category_tarif_class.service_category_one_time_id.blank?
          search_regexs = [/:complete, :tarif_payments, :onetime_payment/i, /:tarif_payments, :onetime_payment/i]
          find_first_from_array_by_array_of_regex(original_global_categories, search_regexs)
        when !first_service_category_tarif_class.service_category_periodic_id.blank?
          search_regexs = [/:complete, :tarif_payments, :fixed_payment/i, /:tarif_payments, :fixed_payment/i]
          find_first_from_array_by_array_of_regex(original_global_categories, search_regexs)
        else
          existing_gcs = first_service_category_tarif_class.uniq_service_category.split('/')
          search_regexs = [
            /:complete, :over_included_in_tarif, :#{existing_gcs[0]}, :#{existing_gcs[1]}/i,
            /:complete, :over_included_in_tarif, :tarif_rouming, :#{existing_gcs[1]}/i,
          ]
          select_first_from_array_by_array_of_regex(original_global_categories, search_regexs)[0]
        end
      else
        existing_gcs = first_service_category_tarif_class.uniq_service_category.split('/')
        search_regexs = [
          /:complete, :included_in_tarif, :#{existing_gcs[0]}, :#{existing_gcs[1]}/i,
          /:complete, :included_in_tarif, :tarif_rouming, :#{existing_gcs[1]}/i,
        ]
        select_first_from_array_by_array_of_regex(original_global_categories, search_regexs)[0]
      end
      
      if !first_matched_original_global_category.blank?
        result['categories_to_select'] = {}
        result['categories_to_select']['global_category'] = [first_matched_original_global_category]

        first_matched_original_global_category = ((first_matched_original_global_category.split(/[^[[:word:]]]+/) || []) - [''])
        
        result['global_category_item'] = {}
        first_matched_original_global_category.each_with_index do |global_category_item, index|
          result['global_category_item'][index.to_s] ||= []
          result['global_category_item'][index.to_s] += ([global_category_item] - result['global_category_item'][index.to_s])
        end        
      end
      
      result
    end
    
    def restore_auto_update_params_for_sctc_regions(service_category_group, formula_param_to_restore) #formula_param_to_set
      return "no service_category_group" if service_category_group.blank?
      raise(StandardError) if false
      return "no formula_param_to_restore" if formula_param_to_restore.blank?
      params_to_restore = service_category_group.try(:params_to_auto_update_formula_params).try(:[], formula_param_to_restore)
      return "no params_to_restore" if params_to_restore.blank?
      result = {
        'use_any_service_as_source_of_parsed_results' => params_to_restore['use_any_service_as_source_of_parsed_results'],
        "tarif_class_id_to_use_as_source_of_parsed_results" => params_to_restore['tarif_class_id_to_use_as_source_of_parsed_results'].try(:to_s),
        'formula_param_to_set' => params_to_restore['formula_param_to_set'],
        'accept_results_with_multiple_regions' => params_to_restore['accept_results_with_multiple_regions'],
        'field_value_array_index' => params_to_restore['field_value_array_index'].try(:to_s),
        'use_any_field_value_array_index_if_value_nil' => params_to_restore['use_any_field_value_array_index_if_value_nil'],
        'use_day_multiplier' => params_to_restore['use_day_multiplier'],
        'use_as_base_param' => params_to_restore['use_as_base_param'],
        'categories_to_select' => params_to_restore['categories_to_select'],
        'if_to_filtr_categories_to_select_by_word' => params_to_restore['if_to_filtr_categories_to_select_by_word'],
        'filtr_categories_to_select_by_word' => params_to_restore['filtr_categories_to_select_by_word'],
      }
      result['global_category_item'] = {}
      all_global_category_items = []
      (params_to_restore['categories_to_select'].try(:[], 'global_category') || []).each do |global_category_as_string|
        global_category_items = ((global_category_as_string.split(/[^[[:word:]]]+/) || []) - [''])
        all_global_category_items = if all_global_category_items.blank?
          global_category_items
        else
          (all_global_category_items & global_category_items)
        end         
      end

      all_global_category_items.each_with_index do |global_category_item, index|
        result['global_category_item'][index.to_s] ||= []
        result['global_category_item'][index.to_s] += ([global_category_item] - result['global_category_item'][index.to_s])
      end

      result
    end
    
    def find_first_from_array_by_array_of_regex(seachable_array, array_of_regex)
      array_of_regex.each do |regex|
        result = seachable_array.find{|search_item| search_item =~ regex}
        return result if result
      end
      nil
    end
    
    def select_first_from_array_by_array_of_regex(seachable_array, array_of_regex)
      array_of_regex.each do |regex|
        result = seachable_array.select{|search_item| search_item =~ regex}
        return result if !result.blank?
      end
      []
    end
    
    def selected_parsed_global_categories_iterator(params_for_update)
      tarif_class_id_to_use_as_source_of_parsed_results = params_for_update['tarif_class_id_to_use_as_source_of_parsed_results']
      selected_saved_service_description_value_keys = params_for_update['categories_to_select']
      field_value_array_index = params_for_update['field_value_array_index']
      use_any_field_value_array_index_if_value_nil = params_for_update['use_any_field_value_array_index_if_value_nil']
      use_day_multiplier = params_for_update['use_day_multiplier']
      use_as_base_param = params_for_update['use_as_base_param']
      filtr_categories_to_select_by_word = params_for_update['filtr_categories_to_select_by_word'] || {}
      
      TarifList.joins(:tarif_class, :region).where(:tarif_class => tarif_class_id_to_use_as_source_of_parsed_results).
        select("categories.name as region_name, tarif_lists.*").map do |tarif_list_item|
          all_global_categories = (tarif_list_item.current_saved_service_desc.try(:keys) || [])
          global_categories_to_select = selected_saved_service_description_value_keys.try(:[], "global_category").blank? ? 
            all_global_categories :
            (all_global_categories & selected_saved_service_description_value_keys.try(:[], "global_category"))

          global_categories_to_select.each do |global_category|
            global_values = tarif_list_item.current_saved_service_desc.try(:[], global_category) || []            
            global_values.each do |global_value|
              keep_global_value = true
              ['service_desc_group_name', 'service_desc_sub_group_name', 'field_name'].each do |saved_desc_value_key|
                if !selected_saved_service_description_value_keys[saved_desc_value_key].blank? and 
                  !selected_saved_service_description_value_keys[saved_desc_value_key].include?(global_value[saved_desc_value_key])
                  keep_global_value = false
                  break
                end
              end
              
              if keep_global_value
                if !filtr_categories_to_select_by_word.try(:[], 'word').blank?
                  categories_to_select_by_word = (filtr_categories_to_select_by_word.try(:[], 'category') || []).map do |saved_desc_value_key|
                    global_value[saved_desc_value_key]
                  end.join(' ')
                  words_in_categories_to_select_by_word = categories_to_select_by_word.gsub(',', '').split(' ').select{|word| word.size > 2 or word.to_i > 0}

                  next if (words_in_categories_to_select_by_word & (filtr_categories_to_select_by_word.try(:[], 'word') || [])).blank?
                end
                
                uniq_key = "#{tarif_list_item['region_name']}////#{global_category}////#{global_value.values.join('////')}".gsub(' ', '')
                
                global_value_to_add = global_value.dup
                if !field_value_array_index.blank?
                  global_value_to_add['param_value'] = text_to_formula_params(global_value_to_add['param_value'][field_value_array_index.try(:to_i)], use_day_multiplier)
                  
                  if global_value_to_add['param_value'].nil? and use_any_field_value_array_index_if_value_nil == 'true'
                    ((global_value.try(:[], 'param_value') || []) - [field_value_array_index.to_i]).each do |trial_param_value|
                      global_value_to_add['param_value'] = text_to_formula_params(trial_param_value)
                      break if global_value_to_add['param_value']
                    end
                  end
                end     

                yield [uniq_key, tarif_list_item, global_value_to_add]             

              end
            end
          end
        end
    end
    
    def selected_parsed_global_categories(params_for_update)
      result = []
      selected_parsed_global_categories_iterator(params_for_update) do |uniq_key, tarif_list_item, global_value_to_add|        
        result << {'uniq_key' => uniq_key, 'region_name' => tarif_list_item['region_name']}.merge(global_value_to_add)  
      end
      result
    end
    
    def update_params_for_formula(service_category_group)
      formula_params_for_update = (service_category_group.try(:params_to_auto_update_formula_params).try(:keys) || []) - ['regions_for_sctc'] - ['deduct_from_params']
      return 'no_params_for_formula_params_auto_update' if formula_params_for_update.blank?
      
      service_category_group.status_of_auto_update ||= {}
      service_category_group.status_of_auto_update['formula_params'] = {'modified' => 'false', 'syncronised' => 'failed', 'updated' => Time.now}
      service_category_group.save!

      temp_param_values_groupped_by_regions = calculate_temp_param_values_groupped_by_regions(service_category_group, formula_params_for_update)      

      param_values_groupped_by_regions = {}
      temp_param_values_groupped_by_regions.each do |region_id, values_groupped_by_formula_param| 
        param_values_groupped_by_regions[values_groupped_by_formula_param] ||= []
        param_values_groupped_by_regions[values_groupped_by_formula_param] << region_id
      end if temp_param_values_groupped_by_regions != "multiple_regions_for_formula_params_auto_update"
        
      return 'no_region_ids_for_formula_params_auto_update' if param_values_groupped_by_regions.values.flatten.blank?
      
      price_list = service_category_group.try(:price_lists).try(:first)
      return 'no_price_list_for_formula_params_auto_update' if price_list.blank?
      
      original_formula = price_list.try(:formulas).try(:first)
      return 'no_formula_for_formula_params_auto_update' if original_formula.blank?
      
      correct_formulas_size = param_values_groupped_by_regions.keys.size
      
      price_list.formulas[correct_formulas_size..-1].each{|formula| formula.delete} if price_list.formulas.size > correct_formulas_size
              
      (correct_formulas_size - price_list.formulas.size).times.each do |index|           
        price_list.formulas.create(original_formula.attributes.except('id', 'created_at', 'updated_at'))
      end if price_list.formulas.size < correct_formulas_size
      
      price_list.formulas.reload
      
      raise(StandardError) if price_list.formulas.size != correct_formulas_size
              
      param_values_groupped_by_regions.each_with_index do |(values_groupped_by_formula_param, regions), index|
        price_list.formulas[index].params ||= {}
        values_groupped_by_formula_param.each do |formula_param_for_update, param_value|
          price_list.formulas[index].params[formula_param_for_update] = param_value
        end
        price_list.formulas[index].regions = regions
        price_list.formulas[index].save
      end

      service_category_group.status_of_auto_update['formula_params'] = {'modified' => 'false', 'syncronised' => 'true', 'updated' => Time.now}
      service_category_group.save!

    end
    
    def calculate_temp_param_values_groupped_by_regions(service_category_group, formula_params_for_update)
      temp_param_values_groupped_by_regions = {}

      base_params_to_deduct = {}
      formula_params_for_update.each do |formula_param_for_update|
        split_by_base_param = formula_param_for_update.match(/^base_(.*)$/i)
        base_params_to_deduct[split_by_base_param[1]] = split_by_base_param[0] if split_by_base_param and !split_by_base_param[1].blank?

        params_for_update = service_category_group.params_to_auto_update_formula_params[formula_param_for_update].dup
        tarif_class_id_to_use_as_source_of_parsed_results = if params_for_update['tarif_class_id_to_use_as_source_of_parsed_results'].blank?
          service_category_group.tarif_class_id
        else
          params_for_update['tarif_class_id_to_use_as_source_of_parsed_results']
        end
        
        params_for_update.merge!({'tarif_class_id_to_use_as_source_of_parsed_results' => tarif_class_id_to_use_as_source_of_parsed_results,})
        selected_parsed_global_categories_iterator(params_for_update) do |uniq_key, tarif_list_item, global_value_to_add|
          
          next if global_value_to_add['param_value'].blank?
          
          temp_param_values_groupped_by_regions[tarif_list_item.region_id] ||= {}
          raise(StandardError) if false
          return 'multiple_regions_for_formula_params_auto_update' if !temp_param_values_groupped_by_regions[tarif_list_item.region_id][formula_param_for_update].blank? and
            params_for_update['accept_results_with_multiple_regions'] != 'true'
          temp_param_values_groupped_by_regions[tarif_list_item.region_id][formula_param_for_update] = global_value_to_add['param_value']
        end                

        ((service_category_group.params_to_auto_update_formula_params['deduct_from_params'] || {})[formula_param_for_update] || {}).each do |regions_str, deduct_from_params_by_regions|
          regions_to_deduct_to_use = deduct_from_params_by_regions['regions']
          regions_to_deduct_to_use = temp_param_values_groupped_by_regions.keys if regions_to_deduct_to_use.blank?
          regions_to_deduct_to_use.each do |region|
            temp_param_values_groupped_by_regions[region] ||= {}
            temp_param_values_groupped_by_regions[region][formula_param_for_update] ||= 0.0
            case deduct_from_params_by_regions['what']
            when 'multiplier'
              temp_param_values_groupped_by_regions[region][formula_param_for_update] *= (deduct_from_params_by_regions['amount'] || 1.0)
              temp_param_values_groupped_by_regions[region][formula_param_for_update] = temp_param_values_groupped_by_regions[region][formula_param_for_update].round(2)
            else
              temp_param_values_groupped_by_regions[region][formula_param_for_update] -= (deduct_from_params_by_regions['amount'] || 0.0)
            end            
          end
        end
  
      end
      
      temp_param_values_groupped_by_regions = 
        deduct_base_param_values_from_temp_param_values_groupped_by_regions(temp_param_values_groupped_by_regions, base_params_to_deduct) if !base_params_to_deduct.blank?

      temp_param_values_groupped_by_regions
    end
    
    def deduct_base_param_values_from_temp_param_values_groupped_by_regions(temp_param_values_groupped_by_regions, base_params_to_deduct)
      result = {}
      temp_param_values_groupped_by_regions.each do |region, param_values_by_region|        
        param_values_by_region.each do |formula_param_for_update, param_value_by_region|
          next if formula_param_for_update =~ /base_/i and base_params_to_deduct[formula_param_for_update].blank?
          result[region] ||= {}
          result[region][formula_param_for_update] = param_value_by_region - (param_values_by_region[base_params_to_deduct[formula_param_for_update]] || 0.0)
        end
      end
      result
    end
    
    def update_regions_for_service_category_tarif_class(service_category_group)
      if service_category_group.try(:params_to_auto_update_formula_params).try(:[], 'regions_for_sctc').blank?
        (service_category_group.try(:service_category_tarif_classes) || []).each do |service_category_tarif_class|
          service_category_tarif_class.conditions ||= {}
          service_category_tarif_class.conditions['regions'] = []
          service_category_tarif_class.save
        end
      else
        service_category_group.status_of_auto_update ||= {}
        service_category_group.status_of_auto_update['sctc_params'] = {'modified' => 'false', 'syncronised' => 'failed', 'updated' => Time.now}
        service_category_group.save!
  
        service_category_group.params_to_auto_update_formula_params['regions_for_sctc'].each do |service_category_tarif_class_ids_as_string, original_params_for_update|
          params_for_update = original_params_for_update.dup
          if service_category_tarif_class_ids_as_string == '[]'
            region_ids_to_update = []
            params_for_update.except!('field_value_array_index')
            selected_parsed_global_categories_iterator(params_for_update) do |uniq_key, tarif_list_item, global_value_to_add|
              
              region_ids_to_update += ([tarif_list_item.region_id] - region_ids_to_update)
            end
            
            return 'no_region_ids_for_regions_for_sctc_auto_update' if region_ids_to_update.blank?
      
            (service_category_group.try(:service_category_tarif_classes) || []).each do |service_category_tarif_class|
              next if !(service_category_tarif_class.conditions.try(:[], 'tarif_set_must_include_tarif_options') || []).
                include?(params_for_update['tarif_class_id_to_use_as_source_of_parsed_results'].try(:to_i))
              
              service_category_tarif_class.conditions ||= {}
              service_category_tarif_class.conditions['regions'] = region_ids_to_update
              service_category_tarif_class.save
            end
          else
            tarif_class_id_to_use_as_source_of_parsed_results = if params_for_update['tarif_class_id_to_use_as_source_of_parsed_results'].blank?
              service_category_group.tarif_class_id
            else
              params_for_update['tarif_class_id_to_use_as_source_of_parsed_results']
            end
            
            service_category_tarif_class_ids = ((service_category_tarif_class_ids_as_string.split(/[^[[:word:]]]+/) || []) - ['']).map(&:to_i)
            
            region_ids_to_update = []
            params_for_update.except!('field_value_array_index').
              merge!({'tarif_class_id_to_use_as_source_of_parsed_results' => tarif_class_id_to_use_as_source_of_parsed_results,})      
            selected_parsed_global_categories_iterator(params_for_update) do |uniq_key, tarif_list_item, global_value_to_add|
              
              region_ids_to_update += ([tarif_list_item.region_id] - region_ids_to_update)
            end
            
            return 'no_region_ids_for_regions_for_sctc_auto_update' if region_ids_to_update.blank?
      
            (service_category_group.try(:service_category_tarif_classes) || []).each do |service_category_tarif_class|
              next if !service_category_tarif_class_ids.include?(service_category_tarif_class.id)
              
              service_category_tarif_class.conditions ||= {}
              service_category_tarif_class.conditions['regions'] = region_ids_to_update
              service_category_tarif_class.save
            end
          end
        end

        service_category_group.status_of_auto_update['sctc_params'] = {'modified' => 'false', 'syncronised' => 'true', 'updated' => Time.now}
        service_category_group.save!
      end
      
      true
    end
  end

end