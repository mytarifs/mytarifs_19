module TarifClassesHelper::ParsedTarifListsHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::ArrayOfHashable, 
    SavableInSession::Tableable, SavableInSession::SessionInitializers
  
  def parsed_tarif_lists_tarif_class_filtr
    create_filtrable("parsed_tarif_lists_tarif_class")
  end
  
  def parsed_tarif_lists_tarif_class_parser_filtr
    create_filtrable("parsed_tarif_lists_tarif_class_parser")
  end
  
  def parsed_tarif_lists_filtr
    create_filtrable("parsed_tarif_lists")
  end
  
  def process_parsed_tarif_lists_filtr
    filtr = params['parsed_tarif_lists_filtr']
    tarif_class_filtr = session[:filtr]['parsed_tarif_lists_tarif_class_filtr'] || {}

    if filtr.try(:[], 'save_parsed_service_for_filtered_tarif_list') == 'true'
      TarifClassesHelper::ProcessParsedTarifLists.run('save_parsed_service_for_filtered_tarif_list', filtr, tarif_class_filtr)
    end
  end

  def tarif_classes_for_parsed_tarif_lists
    return @tarif_classes_for_parsed_tarif_lists if @tarif_classes_for_parsed_tarif_lists
    tarif_class_filtr = session[:filtr]['parsed_tarif_lists_tarif_class_filtr'] || {}
    
    model = TarifClass.
      where(:operator_id => tarif_class_filtr['operator_id'].try(:to_i)).
      where(:standard_service_id => tarif_class_filtr['standard_service_id'].try(:to_i)).
      where(:privacy_id => tarif_class_filtr['privacy_id'].try(:to_i)).
      where(where_for_service_category(tarif_class_filtr)).
      for_parsing('false').
      order(:name)
    model = model.original_tarif_class if tarif_class_filtr['hide_secondary_tarif_class'] == 'true'
    @tarif_classes_for_parsed_tarif_lists = model
  end
  
  def parsed_tarif_lists_model
    return @parsed_tarif_lists_model if @parsed_tarif_lists_model
    parsed_tarif_lists_filtr = session[:filtr]['parsed_tarif_lists_filtr'] || {}
    region_ids = ((parsed_tarif_lists_filtr['region_id'] || []) - ['']).map(&:to_i)
    
    tarif_class_filtr = session[:filtr]['parsed_tarif_lists_tarif_class_filtr'] || {}
    parsed_tarif_class = TarifClass.where(:id => tarif_class_filtr['tarif_class_id'].try(:to_i)).first
    
    model = TarifList.includes(:tarif_class, :region).joins(:tarif_class).where(:tarif_class_id => parsed_tarif_class.try(:id))
      
    model = model.where(:region_id => region_ids) if !region_ids.blank?
    model = model.where("(tarif_lists.features#>>'{initial_processing, h1}')::text is null") if parsed_tarif_lists_filtr['show_only_empty_h1'] == 'true'
    model = model.where("(tarif_lists.features->>'status')::integer in (#{parsed_tarif_lists_filtr['status'].join(', ')})") if !((parsed_tarif_lists_filtr['status'] || []) - ['']).blank?
    model = model.where("(tarif_lists.features->>'status')::integer is null") if parsed_tarif_lists_filtr['show_null_status'] == 'true'
    model = model.order("tarif_classes.name, tarif_lists.region_id")
    result = {}
    model.each do |tarif_list|
      
      service_desc = case parsed_tarif_lists_filtr['source_for_parsed_service']
      when 'current_saved_parsed_service'; tarif_list.current_saved_service_desc || {};
      when 'prev_saved_parsed_service'; tarif_list.prev_saved_service_desc || {};
      else
        parser = ServiceParser::Runner.init({
          :operator_id => tarif_list.try(:tarif_class).try(:operator_id) || 1030,
          :region_id => tarif_list.try(:region_id) || 1200,
          :tarif_class => tarif_list.try(:tarif_class),
          :parsing_class => tarif_list.try(:tarif_class).try(:parsing_class),
          :original_page => tarif_list.description,
        })
        parser.parse_service
      end
      
      result[(tarif_list.region.try(:name) || tarif_list.region.try(:to_s))] = {
        'url' => (tarif_list.visited_page_url.blank? ? '' : tarif_list.visited_page_url),
        'tarif_list_for_parsing_ids' => tarif_list.features.try(:[], 'tarif_list_for_parsing_ids'),
        'status' => tarif_list.features.try(:[], 'status'),
        'error404' => tarif_list.features.try(:[], 'initial_processing').try(:[], 'error404'),
        'h1' => tarif_list.features.try(:[], 'initial_processing').try(:[], 'h1'),
        'fixed_month_payment' => tarif_list.features.try(:[], 'initial_processing').try(:[], 'fixed_month_payment'),
        'fixed_day_payment' => tarif_list.features.try(:[], 'initial_processing').try(:[], 'fixed_day_payment'),
      }.merge({'service_desc' => service_desc})
    end
    
    @parsed_tarif_lists_model = result
  end

  def parsed_tarif_lists
    parsed_tarif_lists_filtr = session[:filtr]['parsed_tarif_lists_filtr'] || {}
    first_level_fields_to_show = (parsed_tarif_lists_filtr['first_level_fields_to_show'] || []) - ['', 'service_desc']
    hide_service_desc_name = (parsed_tarif_lists_filtr['hide_service_desc_name'] || []) - ['']
    hide_blank_param_values = parsed_tarif_lists_filtr['hide_blank_param_values'] == 'true' ? true : false
    max_value_string_size = parsed_tarif_lists_filtr['max_value_string_size'].blank? ? nil : parsed_tarif_lists_filtr['max_value_string_size'].to_i
    service_desc_fields_to_show = []
    (parsed_tarif_lists_filtr['service_desc_fields_to_show'] || {}).each do |global_index, global_values|
      service_desc_fields_to_show[global_index.to_i] = ((global_values || []) - ['']).map(&:to_sym)
    end      
    
    temp_result = {}
    parsed_tarif_lists_model.each do |region_name, value|
      service_desc = (value.try(:[], 'service_desc') || {})
      if !service_desc_fields_to_show.blank?
        service_desc.each do |original_global_category, service_desc_by_global_category|
          global_category = original_global_category.is_a?(String) ? ((original_global_category.split(/[^[[:word:]]]+/) || []) - ['']).map(&:to_sym) : original_global_category
          global_category.each_with_index do |global_category_item, index|
            if !service_desc_fields_to_show[index].blank? and !service_desc_fields_to_show[index].include?(global_category_item)
              service_desc.extract!(original_global_category)
              break
            end
          end
        end
      end

      temp_result[region_name] = value.slice(*first_level_fields_to_show).merge({'service_desc' => service_desc})
    end

    result = []
    if parsed_tarif_lists_filtr['show_regions_as_columns'] == 'true' and temp_result.keys.size > 0
      column_names = temp_result.keys
      row_names = temp_result[column_names[0]].keys
      row_names.each do |row_name|        
        if row_name == 'service_desc'
          global_categories = temp_result.values.map{|v| v['service_desc'].try(:keys) || []}.flatten(1).uniq
          global_categories.each do |original_global_category|
            global_category = original_global_category.is_a?(String) ? ((original_global_category.split(/[^[[:word:]]]+/) || []) - ['']).map(&:to_sym) : original_global_category
            temp = {}
            column_names.each do |column_name|
              (temp_result[column_name][row_name].try(:[], original_global_category) || []).each do |row_param_by_global_category|   
                uniq_key = [global_category.join('/ ')]
                uniq_key += (['service_desc_group_name', 'service_desc_sub_group_name', 'field_name'] - hide_service_desc_name).map do |service_desc_name|
                  row_param_by_global_category[service_desc_name]
                end
                uniq_key = uniq_key.join('_').gsub(' ', '')

                temp[uniq_key] ||= {}       
                temp[uniq_key]['uniq_key'] = uniq_key
                temp[uniq_key]['completeness'] = global_category[0].to_s
                temp[uniq_key]['tarif_category'] = global_category[1].to_s.gsub('_', ' ')
                temp[uniq_key]['rouming'] = global_category[2].to_s.to_s.gsub('_', ' ')
                temp[uniq_key]['service_type'] = global_category[3].to_s.to_s.gsub('_', ' ')
                temp[uniq_key]['global_category'] = (global_category[4..-1] || []).join('/ ')
                temp[uniq_key]['sort'] = "#{global_category.join('/')}"##{temp['service_desc_group_name']}"# #{service_desc_item_name}"
                temp[uniq_key]['service_desc_group_name'] = row_param_by_global_category['service_desc_group_name'] if !hide_service_desc_name.include?('service_desc_group_name')
                temp[uniq_key]['service_desc_sub_group_name'] = row_param_by_global_category['service_desc_sub_group_name'] if !hide_service_desc_name.include?('service_desc_sub_group_name')
                if !hide_service_desc_name.include?('field_name')
                  temp[uniq_key]['field_name'] = max_value_string_size ? row_param_by_global_category['field_name'][0..max_value_string_size] : row_param_by_global_category['field_name']
                end
                
                field_value = (row_param_by_global_category.try(:[], 'param_value') || [])
                if !(hide_blank_param_values and !(['', 'blank'] & field_value).blank?)
                  temp[uniq_key][column_name] ||= []            
                  temp[uniq_key][column_name] += (field_value - temp[uniq_key][column_name])                
                end
              end
            end

            if hide_blank_param_values
              temp.values.map{|value| result << value if !value.slice(*column_names).keys.blank? }
            else
              result += temp.values if !temp.blank?
            end
          end
        else
          temp = {}
          temp['uniq_key'] = row_name
          temp['completeness'] = row_name
          temp['tarif_category'] = ''
          temp['rouming'] = ''
          temp['service_type'] = ''
          temp['global_category'] = ''
          temp['sort'] = "#{row_name}"
          temp['service_desc_group_name'] = ''  if !hide_service_desc_name.include?('service_desc_group_name')
          temp['service_desc_sub_group_name'] = ''  if !hide_service_desc_name.include?('service_desc_sub_group_name')
          temp['field_name'] = row_name  if !hide_service_desc_name.include?('field_name')
          column_names.each{|column_name| temp[column_name] = temp_result[column_name][row_name]}
          result << temp
        end
      end
      result.sort_by!{|r| r['sort'] }      
    else
      temp_result.each{|k, v| result << {'region_name' => k}.merge(v)}
    end
    result = [{}] if result.blank?

    options = {:base_name => 'parsed_tarif_lists', :current_id_name => 'uniq_key', :id_name => 'uniq_key', :pagination_per_page => ((parsed_tarif_lists_filtr['row_per_page'].try(:to_i) || 1) * 20 || 5000)}
    create_array_of_hashable(result, options)
  end


end
