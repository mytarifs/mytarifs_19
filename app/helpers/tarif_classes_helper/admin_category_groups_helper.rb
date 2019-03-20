module TarifClassesHelper::AdminCategoryGroupsHelper

  def service_categories
    options = {:base_name => 'service_categories', :current_id_name => 'service_categories_id', :pagination_per_page => 10}
    create_tableable(Service::CategoryTarifClass.
      includes(:service_category_one_time, :service_category_periodic).
      where(:as_standard_category_group_id => session[:current_id]['category_group_id']).
      order("conditions->>'tarif_set_must_include_tarif_options' DESC"). 
      order(:as_standard_category_group_id, :uniq_service_category), options )
  end

  def price_formulas
    options = {:base_name => 'price_formulas', :current_id_name => 'price_formula_id', :pagination_per_page => 10}
    create_tableable(Price::Formula.joins(price_list: :service_category_group).where(:service_category_groups => {:id => session[:current_id]['category_group_id']}), options)
  end

  def price_standard_formulas
    options = {:base_name => 'price_standard_formulas', :current_id_name => 'price_standard_formula_id', :pagination_per_page => 10}
    create_tableable(Price::StandardFormula.includes(:price_unit, :volume, :volume_unit).joins(:formulas).where(:price_formulas => {:id => session[:current_id]['price_formula_id']}), options)
  end
  
  def admin_category_groups_filtr
    create_filtrable("admin_category_groups_filtr")
  end
  
  def process_admin_category_groups_filtr_actions
    filtr = params['admin_category_groups_filtr_filtr']

    if filtr.try(:[], 'copy_service_category_group_to_another_service') == 'true' and 
       filtr['service_id_to_copy_to'].try(:to_i) > 0 and filtr['service_category_tarif_class_id_to_copy'].try(:to_i) > 0
      service_id_to_copy_to = filtr['service_id_to_copy_to'].try(:to_i)
      service_category_tarif_class = Service::CategoryTarifClass.where(:id => filtr['service_category_tarif_class_id_to_copy'].try(:to_i)).first
      service_category_tarif_class.as_standard_category_group.copy_full_category_definition(service_id_to_copy_to) if service_category_tarif_class
    end

    if filtr.try(:[], 'replace_all_service_category_groups_in_another_service') == 'true' and filtr.try(:[], 'confirm_replace_all_service_category_groups') == 'true' and 
       filtr['service_id_to_copy_to'].try(:to_i) > 0 and filtr['service_id_to_copy_to'].try(:to_i) != tarif_class.id
      
      params['admin_category_groups_filtr_filtr']['confirm_replace_all_service_category_groups'] = 'false'
      service_id_to_copy_to = filtr['service_id_to_copy_to'].try(:to_i)
      ActiveRecord::Base.transaction do
        Service::CategoryGroup.where(:tarif_class_id => service_id_to_copy_to).destroy_all
        Service::CategoryGroup.where(:tarif_class_id => tarif_class.id).each do |service_category_group|
          service_category_group.copy_full_category_definition(service_id_to_copy_to)
        end
      end      
      flash[:notice] = "replace all_service_category_groups_in_another_service done"  
    end
    
    if filtr.try(:[], 'replace_selected_service_category_groups_in_another_service') == 'true' and filtr.try(:[], 'confirm_replace_selected_service_category_groups') == 'true' and 
       filtr['service_id_to_copy_to'].try(:to_i) > 0 and filtr['service_id_to_copy_to'].try(:to_i) != tarif_class.id
      
      params['admin_category_groups_filtr_filtr']['confirm_replace_selected_service_category_groups'] = 'false'
      if !((filtr.try(:[], 'service_category_group_ids') || []) - ['']).blank? or !filtr.try(:[], 'show_category_groups_with_added_parsed_params').blank?
        flash[:alert] = "clean first service_category_group_ids or show_category_groups_with_added_parsed_params"  
      else
        service_id_to_copy_to = filtr['service_id_to_copy_to'].try(:to_i)
        service_category_group_ids_to_delete = admin_category_groups_query(service_id_to_copy_to, filtr).map{|query_item| query_item.try(:[], 'service_category_group_id') }.compact.uniq
        service_category_group_ids_to_replace = admin_category_groups_query(tarif_class.id, filtr).map{|query_item| query_item.try(:[], 'service_category_group_id') }.compact.uniq
        ActiveRecord::Base.transaction do
          Service::CategoryGroup.where(:id => service_category_group_ids_to_delete).destroy_all
          Service::CategoryGroup.where(:id => service_category_group_ids_to_replace).each do |service_category_group|
            service_category_group.copy_full_category_definition(service_id_to_copy_to)
          end
        end    
        flash[:notice] = "replace selected_service_category_groups_in_another_service done"  
      end
    end

    if filtr.try(:[], 'update_selected_service_category_groups_with_parsed_params') == 'true'
      parser = ServiceParser::Runner.init({:operator_id => tarif_class.try(:operator_id),})
      service_category_group_ids_to_update = admin_category_groups_query(tarif_class.id, filtr).map{|query_item| query_item.try(:[], 'service_category_group_id') }.compact.uniq

#For special case when service_category_groups been copied from another service
      Service::CategoryGroup.where(:id => service_category_group_ids_to_update).each do |service_category_group|
        if false and service_category_group.tarif_class.id == 8938
          update_service_category_group = false
          (service_category_group.params_to_auto_update_formula_params || {}).each do |param_to_update, value_for_update|
            service_desc_group_names = value_for_update.try(:[], 'categories_to_select').try(:[], 'service_desc_group_name')
            next if service_desc_group_names.blank?
            update_service_desc_group_names = false
            new_service_desc_group_names = []
            service_desc_group_names.each do |service_desc_group_name|
              if service_desc_group_name =~ /^Базовый тариф \["Домашний регион \+ Межгород"/i
                update_service_desc_group_names = true
                new_service_desc_group_names << service_desc_group_name.gsub("Базовый тариф [\"Домашний регион + Межгород\"", "Базовый тариф [\"Домашний регион + Межгород + Поездки по России\"")
              else
                new_service_desc_group_names << service_desc_group_name
              end
            end
            if update_service_desc_group_names
              update_service_category_group = true
              value_for_update['categories_to_select']['service_desc_group_name'] = new_service_desc_group_names
            end
          end
          service_category_group.save if update_service_category_group
        end
# end of special case        
        parser.update_params_for_formula(service_category_group) if !service_category_group.params_to_auto_update_formula_params.blank?
        parser.update_regions_for_service_category_tarif_class(service_category_group) if !service_category_group.params_to_auto_update_formula_params.try(:[], 'regions_for_sctc').blank?
      end
    end

  end    


  def category_groups
    options = {:base_name => 'category_groups', :current_id_name => 'service_category_tarif_class_id', :id_name => 'service_category_tarif_class_id', :pagination_per_page => 200}
    create_tableable(admin_category_groups_query(tarif_class.id, session_filtr_params(admin_category_groups_filtr)), options)
  end

  def admin_category_groups_query(service_id_to_filter = -1, filtr = {})
    fields = [
      "service_category_groups.id as service_category_group_id",
      "service_category_groups.name as service_category_group_name",
      "service_category_groups.tarif_class_id as tarif_class_id",
      "service_category_groups.criteria as criteria",
      "service_category_one_time.name as service_category_one_time_name", 
      "service_category_periodic.name as service_category_periodic_name", 
      "service_category_tarif_classes.id as service_category_tarif_class_id", 
      "service_category_tarif_classes.uniq_service_category", 
      "service_category_tarif_classes.filtr", 
      "service_category_tarif_classes.conditions",
      "price_lists.id as price_list_id", 
      "price_formulas.id as price_formula_id",
      "price_formulas.calculation_order",
      "price_formulas.formula",
      "price_standard_formulas.name as standard_formula_name"
    ] 
    order_fieds = "uniq_service_category, filtr, calculation_order, service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options', service_category_tarif_classes.id"
        
    conditions = ["true"]
    global_category_condition = global_category_filtr_from_admin_category_groups_filtr(filtr)

    if !filtr.blank?
      if filtr['show_fixed_service_categories'] == 'true'
        conditions << "(service_category_tarif_classes.service_category_one_time_id is not null or service_category_tarif_classes.service_category_periodic_id is not null)"
      else
        uniq_service_category_filtr = categories_from_admin_category_groups_filtr(filtr).join('|')
        conditions << "service_category_tarif_classes.uniq_service_category SIMILAR TO '(#{uniq_service_category_filtr})%'" if !((filtr['uniq_service_category'].try(:values).try(:flatten) || []) - ['']).blank?
      end            

      conditions << "(#{global_category_condition[1]})"
      
      if !filtr['show_category_groups_with_added_parsed_params'].blank?
        conditions_for_show_category_groups_with_added_parsed_params = "((service_category_groups.criteria->>'params_to_auto_update_formula_params')::text is null or 
          (service_category_groups.criteria->>'params_to_auto_update_formula_params')::text = '{}')"
        conditions << "(not #{conditions_for_show_category_groups_with_added_parsed_params})" if filtr['show_category_groups_with_added_parsed_params'] == 'true'
        conditions << conditions_for_show_category_groups_with_added_parsed_params if filtr['show_category_groups_with_added_parsed_params'] == 'false'        
      end
      
      if !filtr['must_included_services'].blank?
        must_included_services = filtr['must_included_services'].join(', ')
        filtr_condition = filtr['must_included_services_filtr_type'] == 'all' ? '@>' : '&&'
        conditions << "ARRAY(SELECT json_array_elements_text( service_category_tarif_classes.conditions#>'{tarif_set_must_include_tarif_options}' )) #{filtr_condition} '{ #{must_included_services} }'"
      end

      service_category_group_ids = ((filtr['service_category_group_ids'] || []) - ['']).map(&:to_i)
      conditions << "( service_category_groups.id in (#{service_category_group_ids.join(', ')}) )" if !service_category_group_ids.blank?

      regions = ((filtr['regions'] || []) - ['']).map(&:to_i)
      if !regions.blank?
        conditions << "( #{Service::CategoryTarifClass.regions_sql(regions, filtr['regions_filtr_type'])} )" if 
          filtr['to_what_apply_regions_filtr'].blank? or filtr['to_what_apply_regions_filtr'] == 'to_category_only' 

        conditions << "( #{Price::Formula.regions_sql(regions, filtr['regions_filtr_type'])} )" if 
          filtr['to_what_apply_regions_filtr'].blank? or filtr['to_what_apply_regions_filtr'] == 'to_formula_only'         
      end
    
      conditions << "(#{parsed_status_filtr_from_admin_category_groups_filtr(filtr)})"
    end
    
    model = Service::CategoryGroup.
#      distinct("#{order_fieds}").
      select("distinct on (#{order_fieds}) #{fields.join(", ")}").
#      joins(:service_category_tarif_classes, price_lists: [formulas: :standard_formula]).
      joins("left JOIN service_category_tarif_classes ON service_category_tarif_classes.as_standard_category_group_id = service_category_groups.id").
      joins("left JOIN price_lists ON price_lists.service_category_group_id = service_category_groups.id").
      joins("left JOIN price_formulas ON price_formulas.price_list_id = price_lists.id").
      joins("left JOIN price_standard_formulas ON price_standard_formulas.id = price_formulas.standard_formula_id").
      joins("left join service_categories service_category_one_time on service_category_tarif_classes.service_category_one_time_id = service_category_one_time.id").
      joins("left join service_categories service_category_periodic on service_category_tarif_classes.service_category_periodic_id = service_category_periodic.id").
      joins(global_category_condition[0]).
      where(:tarif_class_id => service_id_to_filter).
      where(conditions.join(" and "))
      
   calculation_order = ((filtr['calculation_order'] || []) - ['']).map(&:to_i)
   model = model.where(:price_formulas => {:calculation_order => calculation_order}) if !calculation_order.blank?
   
   model = model.order("uniq_service_category, filtr, calculation_order, service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options' desc").all
  end
  
  def parsed_status_filtr_from_admin_category_groups_filtr(filtr)
    result = ["true"]
    ['formula_params', 'sctc_params'].each do |param_type|
      filtr_for_param_type = filtr.try(:[], 'parsed_status_filtr').try(:[], param_type) || {}
      if !filtr_for_param_type['modified'].blank?
        result << if filtr_for_param_type['modified'] == 'blank'
          "((service_category_groups.criteria#>'{status_of_auto_update, formula_params, modified}')::text is null)"
        else
          "((service_category_groups.criteria#>'{status_of_auto_update, formula_params, modified}')::text = '\"#{filtr_for_param_type['modified']}\"')"
        end
      end
      
      result << "((service_category_groups.criteria#>'{status_of_auto_update, formula_params, syncronised}')::text = '\"#{filtr_for_param_type['syncronised']}\"')" if !filtr_for_param_type['syncronised'].blank?
      result << "((service_category_groups.criteria#>>'{status_of_auto_update, formula_params, updated}')::date - current_date < #{filtr_for_param_type['updated_less_than']})" if !filtr_for_param_type['updated_less_than'].blank?
    end
     
    result.join(" and ")
  end
  
  def global_category_filtr_from_admin_category_groups_filtr(filtr)
    global_key = filtr.try(:[], 'gloabl_category_filtr').try(:[], 'global_key')
    condition = filtr.try(:[], 'gloabl_category_filtr').try(:[], 'condition')
    gloabl_category_id = filtr.try(:[], 'gloabl_category_filtr').try(:[], 'gloabl_category_id')
    
    if !gloabl_category_id.blank? and !global_key.blank?      
      join_name = "#{global_key}_#{condition}"
      [
        "left join jsonb_array_elements_text((service_category_tarif_classes.filtr#>'{#{global_key}, #{condition}}')::jsonb) #{join_name} on true",
        "#{join_name} = '#{gloabl_category_id.constantize}'"
      ]
    else
      ["", "true"]
    end
  end
  
  def categories_from_admin_category_groups_filtr(filtr)
    uniq_service_categories = filtr.try(:[], 'uniq_service_category')
    roumings = ((uniq_service_categories.try(:[], "rouming") || []) - ['']).map(&:to_sym)
    services = ((uniq_service_categories.try(:[], "service") || []) - ['']).map(&:to_sym)
    directions = ((uniq_service_categories.try(:[], "direction") || []) - ['']).map(&:to_sym)
    partners = ((uniq_service_categories.try(:[], "partner") || []) - ['']).map(&:to_sym)
    raise(StandardError, [
      uniq_service_categories
    ]) if false
    
    global_category_parts = []
    roumings.each do |rouming|
      possible_services = (services & Optimization::Global::Base::Structure[rouming].keys)
      if possible_services.blank?
        global_category_parts << [rouming, ].map(&:to_s).join('/')
      else
        possible_services.each do |service|
          possible_directions = (directions & Optimization::Global::Base::Structure[rouming][service].keys)
          if possible_directions.blank?
            global_category_parts << [rouming, service, ].map(&:to_s).join('/')
          else
            possible_directions.each do |direction|
              possible_partners = (partners & Optimization::Global::Base::Structure[rouming][service][direction].keys)
              if possible_partners.blank?
                global_category_parts << [rouming, service, direction, ].map(&:to_s).join('/')
              else
                possible_partners.each do |partner|
                  global_category_parts << [rouming, service, direction, partner].map(&:to_s).join('/')
                end
              end
            end
          end
        end
      end
    end
    raise(StandardError, [
      uniq_service_categories,
      global_category_parts
    ]) if false
    global_category_parts
  end


end
