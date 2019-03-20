module Service::CategoryGroupsHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::ArrayOfHashable, SavableInSession::SessionInitializers

  def service_category_group
    @service_category_group
  end
  
  def category_tarif_classes
    model = Service::CategoryTarifClass.includes(:service_category_one_time, :service_category_periodic).where({:as_standard_category_group_id => service_category_group.try(:id)})

    options = {:base_name => 'category_tarif_classes', :current_id_name => 'category_tarif_class_id', :id_name => 'id', :pagination_per_page => 100}
    create_tableable(model, options)
  end

  def price_formulas
    model = Price::Formula.includes(:standard_formula).where({:price_list_id => service_category_group.try(:price_lists).try(:first).try(:id)})

    options = {:base_name => 'price_formulas', :current_id_name => 'formula_id', :id_name => 'id', :pagination_per_page => 100}
    create_tableable(model, options)
  end

  def service_category_group_filtr
    create_filtrable("service_category_group")
  end  
  
  def selected_parsed_global_categories
    options = {:base_name => 'selected_parsed_global_categories', :current_id_name => 'uniq_key', :id_name => 'uniq_key', :pagination_per_page => 100}
    create_array_of_hashable(selected_parsed_global_categories_model, options)    
  end

  def selected_parsed_global_categories_model
    filtr = session[:filtr]['service_category_group_filtr'] || {}
    result = []
    
    if !filtr['categories_to_select'].try(:[], 'global_category').blank?
      parser = ServiceParser::Runner.init({
        :operator_id => service_category_group.try(:tarif_class).try(:operator_id),
      })
      tarif_class_id_to_use_as_source_of_parsed_results = filtr['tarif_class_id_to_use_as_source_of_parsed_results'].try(:to_i) || service_category_group.tarif_class_id
      
      params_for_update = {
        'tarif_class_id_to_use_as_source_of_parsed_results' => tarif_class_id_to_use_as_source_of_parsed_results,
      }.merge(filtr.slice(
        'categories_to_select', 'field_value_array_index', 'filtr_categories_to_select_by_word', 'use_any_field_value_array_index_if_value_nil', 'use_day_multiplier', 'use_as_base_param'))

      result = parser.selected_parsed_global_categories(params_for_update)
    end
    
    result = [{}] if result.blank?
    result.sort_by!{|r| r['uniq_key'] }
    result
  end
    
  def process_action_buttons
    filtr = params['service_category_group_filtr'] || {}

    if filtr['guess_auto_update_params_for_formula'] == 'true'
      parser = ServiceParser::Runner.init({
        :operator_id => service_category_group.try(:tarif_class).try(:operator_id),
      })
      params['service_category_group_filtr'] = parser.guess_auto_update_params_for_formula(service_category_group)
      
#to check if tarif_class_id_to_use_as_source_of_parsed_results is incorrect for all Service::CategoryGroup
      if false
        index = 0
        Service::CategoryGroup.includes(:tarif_class, :service_category_tarif_classes).where("(service_category_groups.criteria#>'{params_to_auto_update_formula_params}')::text is not null").
        each do |scg|
          scg.params_to_auto_update_formula_params.each do |param_to_update, value_for_update|
            next if value_for_update.try(:[], "tarif_class_id_to_use_as_source_of_parsed_results").blank?
            next if !value_for_update.try(:[], "use_any_service_as_source_of_parsed_results").blank?
            tarif_set_must_include_tarif_options = scg.service_category_tarif_classes.
              map{|sctc| sctc.conditions.try(:[], 'tarif_set_must_include_tarif_options') || []}.flatten.uniq.map(&:to_i)
            next if tarif_set_must_include_tarif_options.include?(value_for_update.try(:[], "tarif_class_id_to_use_as_source_of_parsed_results").to_i)
  
            index += 1
            if false and value_for_update.try(:[], "tarif_class_id_to_use_as_source_of_parsed_results").to_i == 8977 and scg.tarif_class.id == 8976
  #            value_for_update.try(:[], "tarif_class_id_to_use_as_source_of_parsed_results").to_i == scg.tarif_class_id
  #            value_for_update['use_any_service_as_source_of_parsed_results'] = 'true'
  #            value_for_update['tarif_class_id_to_use_as_source_of_parsed_results'] = nil
  #            scg.save!
              puts "#{index} correct scg.tarif_class.id #{[scg.tarif_class.id, scg.tarif_class.name, scg.tarif_class.operator_id, tarif_set_must_include_tarif_options]} scg.id =#{scg.id}"
  #            puts "#{index} correct scg.tarif_class.id #{[scg.tarif_class.id, scg.tarif_class.name, scg.tarif_class.operator_id]} scg.id =#{scg.id} #{[scg.params_to_auto_update_formula_params[param_to_update].try(:[], 'tarif_class_id_to_use_as_source_of_parsed_results')]}"
            else
              puts "#{index} wrong scg.tarif_class.id #{[scg.tarif_class.id, scg.tarif_class.name, scg.tarif_class.operator_id]} #{scg.id} #{[scg.params_to_auto_update_formula_params[param_to_update].try(:[], 'tarif_class_id_to_use_as_source_of_parsed_results')]}"
            end
          end
        end
      end
    end

    if filtr['restore_auto_update_params_for_sctc_regions'] == 'true'
      parser = ServiceParser::Runner.init({
        :operator_id => service_category_group.try(:tarif_class).try(:operator_id),
      })
      restore_result = parser.restore_auto_update_params_for_sctc_regions(service_category_group, filtr['formula_param_to_set'])
      params['service_category_group_filtr'] = restore_result.is_a?(Hash) ? restore_result : {}
    end

    if filtr['delete_params_for_formula_auto_update_from_saved_parsed_results'] == 'true' and !filtr['formula_param_to_set'].blank?
      service_category_group.params_to_auto_update_formula_params ||= {}
      service_category_group.status_of_auto_update ||= {}
      
      formula_param_to_set = filtr['formula_param_to_set']
      formula_param_to_set = 'base_' + formula_param_to_set if filtr['use_as_base_param'] == 'true'
      service_category_group.params_to_auto_update_formula_params.extract!(formula_param_to_set)   
         
      service_category_group.status_of_auto_update['formula_params'] = if service_category_group.params_to_auto_update_formula_params.blank?
        {'modified' => 'false', 'syncronised' => 'true', 'updated' => Time.now}
      else
        {'modified' => 'true', 'syncronised' => 'false', 'updated' => Time.now}
      end      
      
      service_category_group.save
    end

    if filtr['delete_regions_auto_update_for_sctc_from_saved_parsed_results'] == 'true'
      service_category_group.params_to_auto_update_formula_params ||= {}
      service_category_group.status_of_auto_update ||= {}
      
      service_category_group.params_to_auto_update_formula_params['regions_for_sctc'] ||= {}
      service_category_group.params_to_auto_update_formula_params['regions_for_sctc'].keys.each do |service_category_tarif_classes_key|
        service_category_tarif_classes = ((service_category_tarif_classes_key.split(/[^[[:word:]]]+/) || []) - ['']).map(&:to_i).sort
        service_category_group.params_to_auto_update_formula_params['regions_for_sctc'].extract!(service_category_tarif_classes_key) if 
          service_category_tarif_classes == filtr['service_category_tarif_classes_to_set'].try(:sort)
      end
      
#      service_category_group.params_to_auto_update_formula_params['regions_for_sctc'].extract!(filtr['service_category_tarif_classes_to_set'].try(:sort).try(:to_s))
      
      possible_sctc_ids = service_category_group.service_category_tarif_classes.pluck(:id)      
      service_category_group.params_to_auto_update_formula_params['regions_for_sctc'].each do |original_sctc_key, value|
        sctc_key = ((original_sctc_key.split(/[^[[:word:]]]+/) || []) - ['']).map(&:to_i)
        service_category_group.params_to_auto_update_formula_params['regions_for_sctc'].
          extract!(original_sctc_key) if (sctc_key & possible_sctc_ids).size != sctc_key.size
      end
      raise(StandardError) if false
      service_category_group.params_to_auto_update_formula_params.extract!('regions_for_sctc') if service_category_group.params_to_auto_update_formula_params['regions_for_sctc'].blank?
      
      service_category_group.status_of_auto_update['sctc_params'] = if service_category_group.params_to_auto_update_formula_params.blank?
        {'modified' => 'false', 'syncronised' => 'true', 'updated' => Time.now}
      else
        {'modified' => 'true', 'syncronised' => 'false', 'updated' => Time.now}
      end      
      
      service_category_group.save
    end

    if filtr['delete_params_for_formula_auto_update_deduct_from_params'] == 'true' and !service_category_group.params_to_auto_update_formula_params.try(:[], 'deduct_from_params').blank?
      service_category_group.params_to_auto_update_formula_params ||= {}
      service_category_group.status_of_auto_update ||= {}
      
      service_category_group.params_to_auto_update_formula_params['deduct_from_params'][filtr['deduct_from_params_formula_param_to_set']] ||= {}
      service_category_group.params_to_auto_update_formula_params['deduct_from_params'][filtr['deduct_from_params_formula_param_to_set']].extract!(filtr['deduct_from_params_regions'].try(:to_s))
      service_category_group.params_to_auto_update_formula_params['deduct_from_params'].extract!('deduct_from_params_formula_param_to_set') if 
        service_category_group.params_to_auto_update_formula_params['deduct_from_params']['deduct_from_params_formula_param_to_set'].blank?
      service_category_group.params_to_auto_update_formula_params.extract!('deduct_from_params') if service_category_group.params_to_auto_update_formula_params['deduct_from_params'].blank?
      
      service_category_group.status_of_auto_update['formula_params'] = if service_category_group.params_to_auto_update_formula_params.blank?
        {'modified' => 'false', 'syncronised' => 'true', 'updated' => Time.now}
      else
        {'modified' => 'true', 'syncronised' => 'false', 'updated' => Time.now}
      end      
      
      service_category_group.save
    end

    if filtr['add_params_for_formula_auto_update_from_saved_parsed_results'] == 'true' or filtr['add_regions_auto_update_for_sctc_from_saved_parsed_results'] == 'true'
      check_all_params_in_place = if filtr['add_params_for_formula_auto_update_from_saved_parsed_results'] == 'true'
        (!params["service_category_group_filtr"]['formula_param_to_set'].blank? and
        !params["service_category_group_filtr"]['field_value_array_index'].blank? and 
        !params["service_category_group_filtr"]['categories_to_select'].blank?)
      else
        first_condition = (!params["service_category_group_filtr"]['tarif_class_id_to_use_as_source_of_parsed_results'].blank? or
          !params["service_category_group_filtr"]['service_category_tarif_classes_to_set'].blank?)
        (first_condition and !params["service_category_group_filtr"]['categories_to_select'].blank?)
      end
        
      check_results_for_multiple_regions = true
      if filtr['accept_results_with_multiple_regions'] != 'true'
        check_by_region = {}
        selected_parsed_global_categories_model.each do |result_item|
          region_to_check = result_item['region_name']
          check_by_region[region_to_check] = (check_by_region[region_to_check] || 0) + 1
          check_results_for_multiple_regions = false if check_by_region[region_to_check] > 1
          break if !check_results_for_multiple_regions
        end
        
      end

      if check_all_params_in_place and check_results_for_multiple_regions
        service_category_group.params_to_auto_update_formula_params ||= {}
        service_category_group.status_of_auto_update ||= {}
        if filtr['add_params_for_formula_auto_update_from_saved_parsed_results'] == 'true'
          formula_param_to_set = filtr['formula_param_to_set']
          formula_param_to_set = 'base_' + formula_param_to_set if filtr['use_as_base_param'] == 'true'
          service_category_group.params_to_auto_update_formula_params[formula_param_to_set] = {
            'use_any_service_as_source_of_parsed_results' => filtr['use_any_service_as_source_of_parsed_results'],
            "tarif_class_id_to_use_as_source_of_parsed_results" => filtr['tarif_class_id_to_use_as_source_of_parsed_results'].try(:to_i),
            'formula_param_to_set' => filtr['formula_param_to_set'],
            'accept_results_with_multiple_regions' => filtr['accept_results_with_multiple_regions'],
            'field_value_array_index' => filtr['field_value_array_index'].try(:to_i),
            'use_any_field_value_array_index_if_value_nil' => filtr['use_any_field_value_array_index_if_value_nil'],
            'use_day_multiplier' => filtr['use_day_multiplier'],
            'use_as_base_param' => filtr['use_as_base_param'],
            'categories_to_select' => filtr['categories_to_select'],
            'if_to_filtr_categories_to_select_by_word' => filtr['if_to_filtr_categories_to_select_by_word'],
            'filtr_categories_to_select_by_word' => (filtr['filtr_categories_to_select_by_word'] || {}),
          }
          
          service_category_group.status_of_auto_update['formula_params'] = if service_category_group.params_to_auto_update_formula_params.blank?
            {'modified' => 'false', 'syncronised' => 'true', 'updated' => Time.now}
          else
            {'modified' => 'true', 'syncronised' => 'false', 'updated' => Time.now}
          end      
        else
          service_category_group.params_to_auto_update_formula_params['regions_for_sctc'] ||= {}
          service_category_group.params_to_auto_update_formula_params['regions_for_sctc'][filtr['service_category_tarif_classes_to_set'].try(:sort).try(:to_s)] = {
            "tarif_class_id_to_use_as_source_of_parsed_results" => filtr['tarif_class_id_to_use_as_source_of_parsed_results'].try(:to_i),
            'accept_results_with_multiple_regions' => filtr['accept_results_with_multiple_regions'],
            'categories_to_select' => filtr['categories_to_select'],
          }
          service_category_group.status_of_auto_update['sctc_params'] = if service_category_group.params_to_auto_update_formula_params.blank?
            {'modified' => 'false', 'syncronised' => 'true', 'updated' => Time.now}
          else
            {'modified' => 'true', 'syncronised' => 'false', 'updated' => Time.now}
          end      
        end 
        service_category_group.save
      end
      
    end

    if filtr['add_params_for_formula_auto_update_deduct_from_params'] == 'true'
      check_all_params_in_place = (
        !filtr['deduct_from_params_what'].blank? and
        !filtr['deduct_from_params_regions'].nil? and 
        !filtr['deduct_from_params_formula_param_to_set'].blank? and
        !filtr['deduct_from_params_amount'].blank?
      )
      
      if check_all_params_in_place
        service_category_group.params_to_auto_update_formula_params ||= {}
        service_category_group.params_to_auto_update_formula_params['deduct_from_params'] ||= {}
        service_category_group.params_to_auto_update_formula_params['deduct_from_params'][filtr['deduct_from_params_formula_param_to_set']] ||= {}
        service_category_group.params_to_auto_update_formula_params['deduct_from_params'][filtr['deduct_from_params_formula_param_to_set']][filtr['deduct_from_params_regions']] = {
          "what" => filtr['deduct_from_params_what'],
          "regions" => filtr['deduct_from_params_regions'],
          "amount" => filtr['deduct_from_params_amount'],
        }

        service_category_group.status_of_auto_update ||= {}
        service_category_group.status_of_auto_update['formula_params'] = if service_category_group.params_to_auto_update_formula_params.blank?
          {'modified' => 'false', 'syncronised' => 'true', 'updated' => Time.now}
        else
          {'modified' => 'true', 'syncronised' => 'false', 'updated' => Time.now}
        end      

        service_category_group.save        
      end
    end

    if filtr['update_params_for_formula_from_saved_parsed_results'] == 'true'
      parser = ServiceParser::Runner.init({:operator_id => service_category_group.try(:tarif_class).try(:operator_id)})
      result = parser.update_params_for_formula(service_category_group)
    end

    if filtr['update_regions_for_sctc_from_saved_parsed_results'] == 'true'
      parser = ServiceParser::Runner.init({:operator_id => service_category_group.try(:tarif_class).try(:operator_id)})
      result = parser.update_regions_for_service_category_tarif_class(service_category_group)
    end

  end
  
  def check_category_group_params_before_edit
    if params["service_category_group_filtr"]
      params["service_category_group_filtr"]['use_any_service_as_source_of_parsed_results'] = nil if params["service_category_group_filtr"]['use_any_service_as_source_of_parsed_results'].blank?
      params["service_category_group_filtr"]['tarif_class_id_to_use_as_source_of_parsed_results'] = nil if params["service_category_group_filtr"]['tarif_class_id_to_use_as_source_of_parsed_results'].blank?
      params["service_category_group_filtr"]['formula_param_to_set'] = nil if params["service_category_group_filtr"]['formula_param_to_set'].blank?
      params["service_category_group_filtr"]['accept_results_with_multiple_regions'] = nil if params["service_category_group_filtr"]['accept_results_with_multiple_regions'].blank?
      params["service_category_group_filtr"]['use_any_field_value_array_index_if_value_nil'] = nil if params["service_category_group_filtr"]['use_any_field_value_array_index_if_value_nil'].blank?
      params["service_category_group_filtr"]['use_day_multiplier'] = nil if params["service_category_group_filtr"]['use_day_multiplier'].blank?
      params["service_category_group_filtr"]['use_as_base_param'] = nil if params["service_category_group_filtr"]['use_as_base_param'].blank?
      
      max_chosen_global_category_index = (params["service_category_group_filtr"]['global_category_item'] || {}).keys.size
      max_chosen_global_category_index.times do |global_category_index|
        params["service_category_group_filtr"]['global_category_item'][global_category_index.to_s] ||= []
        params["service_category_group_filtr"]['global_category_item'][global_category_index.to_s] -= ['']
      end 
      
      chosen_global_categories = (params["service_category_group_filtr"]["global_category_item"] || {'0' => 'false_choice'}).values.compact.map{|g| ":#{g}"}
      chosen_global_categories = "#{chosen_global_categories.join(', ')}"
        
      params["service_category_group_filtr"]['categories_to_select'] ||= {}
      ['global_category', 'service_desc_group_name', 'service_desc_sub_group_name', 'field_name'].each do |category_to_select_key|
        params["service_category_group_filtr"]['categories_to_select'][category_to_select_key] ||= []
        params["service_category_group_filtr"]['categories_to_select'][category_to_select_key] -= ['']
      end
      
      params["service_category_group_filtr"]['field_value_array_index'] = nil if params["service_category_group_filtr"]['field_value_array_index'].blank?
      
      if !((params["service_category_group_filtr"].try(:[], 'service_category_tarif_classes_to_set') || []) - ['']).blank?
        params["service_category_group_filtr"]['service_category_tarif_classes_to_set'] ||= []
        params["service_category_group_filtr"]['service_category_tarif_classes_to_set'] -= ['']
        params["service_category_group_filtr"]['service_category_tarif_classes_to_set'] = params["service_category_group_filtr"]['service_category_tarif_classes_to_set'].map(&:to_i)
      else
        params["service_category_group_filtr"]['service_category_tarif_classes_to_set'] = []
      end
      
      params["service_category_group_filtr"]['if_to_filtr_categories_to_select_by_word'] = nil if params["service_category_group_filtr"]['if_to_filtr_categories_to_select_by_word'].blank?

      params["service_category_group_filtr"]['filtr_categories_to_select_by_word'] ||= {}
      params["service_category_group_filtr"]['filtr_categories_to_select_by_word']['category'] ||= []
      params["service_category_group_filtr"]['filtr_categories_to_select_by_word']['category'] -= ['']
      params["service_category_group_filtr"]['filtr_categories_to_select_by_word']['word'] ||= []
      params["service_category_group_filtr"]['filtr_categories_to_select_by_word']['word'] -= ['']

      if !((params["service_category_group_filtr"].try(:[], 'deduct_from_params_regions') || []) - ['']).blank?
        params["service_category_group_filtr"]['deduct_from_params_regions'] ||= []
        params["service_category_group_filtr"]['deduct_from_params_regions'] -= ['']
        params["service_category_group_filtr"]['deduct_from_params_regions'] = params["service_category_group_filtr"]['deduct_from_params_regions'].map(&:to_i)
      else
        params["service_category_group_filtr"]['deduct_from_params_regions'] = []
      end

      params["service_category_group_filtr"]['deduct_from_params_what'] = nil if params["service_category_group_filtr"]['deduct_from_params_what'].blank?
      params["service_category_group_filtr"]['deduct_from_params_formula_param_to_set'] = nil if params["service_category_group_filtr"]['deduct_from_params_formula_param_to_set'].blank?
      params["service_category_group_filtr"]['deduct_from_params_amount'] = params["service_category_group_filtr"]['deduct_from_params_amount'].try(:to_f)
    end
    
  end

end
