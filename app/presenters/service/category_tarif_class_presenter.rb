module Service::CategoryTarifClassPresenter
  RegionFiltrs = {
    :own_country_regions => {:filtr_query => ::Category::Region, :empty_global_filtr => /^own_country_regions/},
#    :to_own_country_regions => {:filtr_query => ::Category::Region, :empty_global_filtr => /to_own_country_regions|mms_out|to_russia/},
    :abroad_countries => {:filtr_query => ::Category::Country, :empty_global_filtr => /^abroad_countries/},
#    :to_other_countries => {:filtr_query => ::Category::Country, :empty_global_filtr => //},
    :to_abroad_countries => {:filtr_query => ::Category::Country, :empty_global_filtr => /to_abroad_countries|mms_out|^abroad_countries\/sms_out|^abroad_countries\/calls_out/},      
  } 
  
  ChosenPhoneTypes = {
    Category::ChosenPhoneNumber::ToFavoriteNumbers => "любимые номера",
    Category::ChosenPhoneNumber::ToContractNumbers => "организацию",
    Category::ChosenPhoneNumber::ToTarifNumbers => "свой тариф",
    Category::ChosenPhoneNumber::ToChosenRegions => "выбранные регионы",
    Category::ChosenPhoneNumber::ToChosenCities => "выбранные города",
    Category::ChosenPhoneNumber::ToChosenWebSites => "выбранные интернет-ресурсы",
  }
  
  InternetType = {
    Category::InternetType::G2 => "G2",
    Category::InternetType::G3 => "G3",
    Category::InternetType::G4 => "G4",
    Category::InternetType::Cdma => "CDMA",
    Category::InternetType::Wifi => "WiFi",
    Category::InternetType::Wap => "WAP",
  }
  
  def merged_constants_for_global_category_4
    ChosenPhoneTypes.merge(InternetType)
  end

  def all_region_keys_to_filter(tarif_class_id_to_show, support_service_id = nil, m_region = 'moskva_i_oblast')
    possible_region_keys_to_filter = RegionFiltrs.keys.map(&:to_s)
    
    additional_from = support_service_id ? ", json_array_elements((service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options')) as support_service_id" : ""
    region_keys_from_tarifs = Service::CategoryTarifClass.
      joins(as_standard_category_group: [:tarif_class, price_lists: :formulas]).
      joins(additional_from).
      where(base_filtr_condition(tarif_class_id_to_show, support_service_id, m_region)). 
      where("filtr is not null").pluck("distinct jsonb_object_keys(filtr)")
      
    raise(StandardError, [
      support_service_id,
      possible_region_keys_to_filter,
      region_keys_from_tarifs
    ]) if false
      
    possible_region_keys_to_filter & region_keys_from_tarifs
  end
  
  def base_filtr_condition(tarif_class_ids_input, support_service_id = nil, m_region = 'moskva_i_oblast')
    tarif_class_ids = !tarif_class_ids_input.is_a?(Array) ? [tarif_class_ids_input] : tarif_class_ids_input
    
    tarif_where_hash = "service_category_groups.tarif_class_id = any('{ #{tarif_class_ids.join(', ')} }')" 
    support_service_where_hash = if support_service_id
      "support_service_id::text::integer = #{support_service_id}"
    else
      "(((service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::jsonb is null) or \
      ((service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options') = '[]'))"
    end
    
    region_id = Category::MobileRegions[m_region].try(:[], 'region_ids'). try(:[], 0)
    region_sql = "( #{TarifClass.regions_sql(region_id)} ) and ( #{Price::Formula.regions_sql(region_id)} ) and ( #{Service::CategoryTarifClass.regions_sql(region_id)} )"

    "( #{tarif_where_hash} ) and ( #{support_service_where_hash} ) and ( #{region_sql} )"
  end

  def category_groups_presenter(full_category_groups, m_region, filtred_regions = {}) 
    result = []; geo_names = []
      
    criteria_value_names = criteria_value_names_from_full_category_groups(full_category_groups, m_region)
    prev_service_category = nil
    formula_ids = []
    full_category_groups.each do |category_group|
      price_to_show = true      
      category_group.service_category_tarif_classes.each do |service_category|
        
        next if !service_category_is_filtered_by_region?(service_category, filtred_regions)

        global_categories = category_presenter(service_category, prev_service_category, criteria_value_names)
        global_categories[3] = "#{global_categories[3][0]} #{criteria_value_names[service_category.id][:operators].join(', ')}" if global_categories[3] and !global_categories[3][1].blank?
        global_categories[4] = "#{global_categories[4][0]} #{merged_constants_for_global_category_4[global_categories[4][1][0]]}" if global_categories[4] and !global_categories[4][1].blank?
        global_categories = global_categories.map{|category_name| Optimization::Global::Base::Dictionary.tr(category_name)}     
        if category_group.price_lists and category_group.price_lists.first.formulas and price_to_show
          raise(StandardError) if false and category_group.price_lists.first.formulas.size > 1
          formula = category_group.price_lists.first.formulas.first
          formula_ids << formula.standard_formula_id
          global_categories << price_presenter(formula, service_category)
        else
          global_categories << nil
        end

        result << global_categories
        geo_names << [nil, 
          (criteria_value_names[service_category.id][:rouming].blank? ? nil : criteria_value_names[service_category.id][:rouming]),
          (criteria_value_names[service_category.id][:geo].blank? ? nil : criteria_value_names[service_category.id][:geo]),
          nil, nil]
        price_to_show = false
        prev_service_category = service_category        
      end if category_group.service_category_tarif_classes            
    end if full_category_groups

    {:result => result_with_colspan(result), :geo_names => geo_names, :asterics => show_asterics_for_formula_details(formula_ids.uniq)}
  end
  
  def service_category_is_filtered_by_region?(service_category, filtred_regions)
    return true if filtred_regions.blank?
    
    condition_for_all_filtered_regions = true    

    operator_id = service_category.tarif_class.operator_id
    tarif_class_region_id = Category::Region::Const::Alaniya
    region_desc = Category::Region::Desc.new(tarif_class_region_id, operator_id)
    
    
    filtred_regions.each do |region_key_to_filter, region_id|
#      next if filtred_regions[region_key_to_filter].blank?
      
      condition_for_filtered_region = false
      
      condition_for_filtered_region = true if service_category.filtr.try(:[], region_key_to_filter).blank? and
        service_category.uniq_service_category =~ RegionFiltrs[region_key_to_filter.to_sym][:empty_global_filtr]
      
      filtr_category_ids = service_category.filtr.try(:[], region_key_to_filter).try(:[], 'in') || [] 
      service_category_filtr_ids = region_desc.region_ids_by_region_types_or_region_ids(filtr_category_ids)
      condition_for_filtered_region = true if !condition_for_filtered_region and service_category_filtr_ids.include?(region_id.to_i)

      raise(StandardError, [
        filtr_category_ids,
        service_category_filtr_ids
      ]) if false and service_category.as_standard_category_group.price_lists[0].formulas[0].try(:formula).try(:[], 'params').try(:[], 'price') == 3.0 and 
        !(service_category.uniq_service_category =~ /own_and_home_regions/)

      filtr_category_ids = service_category.filtr.try(:[], region_key_to_filter).try(:[], 'not_in') || [] 
      service_category_filtr_ids = region_desc.region_ids_by_region_types_or_region_ids(filtr_category_ids)
      condition_for_filtered_region = true if !condition_for_filtered_region and !service_category_filtr_ids.blank? and !service_category_filtr_ids.include?(region_id.to_i)

      condition_for_all_filtered_regions = (condition_for_all_filtered_regions and condition_for_filtered_region)

      return condition_for_all_filtered_regions if !condition_for_all_filtered_regions 
      
    end
    condition_for_all_filtered_regions
  end
  
  def result_with_colspan(result_without_colspan_1)
#    return result_without_colspan
    result = []
    result_without_colspan = result_without_colspan_1.reverse
    result_without_colspan[0].each_index do |col|
      current_row_span = 1
      result_without_colspan.each_index do |row|
        result[row] ||= []
        if result_without_colspan[row][col] or (col > 0 and col < 5 and col != 1 and result[row][col-1][1])
          result[row][col] = [result_without_colspan[row][col], current_row_span]
          current_row_span = 1
        else          
          result[row][col] = [nil, nil]
          current_row_span += 1
        end
      end
    end if result_without_colspan[0]
    result.reverse!
    
      if false and result_without_colspan_1 == [[nil, nil, nil, nil, nil, "16.66 руб / день*"]]
        raise(StandardError) if false
        puts
        puts
        puts
        puts result.to_s
        puts
        puts result_with_colspan(result).to_s
        puts
        puts
      end
      
    if true and result[0] and result[0][1..4] == [[nil, nil], [nil, nil], [nil, nil], [nil, nil]]
      [[result[0][0]] + [["", 1], ["", 1], ["", 1], ["", 1]] + [result[0][5]]] + result[1..result.size]
    else
      result
    end    
  end  
  
  def category_presenter(service_category, prev_service_category, criteria_value_names)
    curr_category = to_compare_format(service_category)
    prev_category = prev_service_category ? to_compare_format(prev_service_category) : [nil, nil, nil, nil, nil]
    i = 0
    category_items_to_show = case
    when (prev_service_category.nil?) #prev_service_category.as_standard_category_group_id != service_category.as_standard_category_group_id)
      i = 1
      [curr_category[0], curr_category[1], curr_category[2], curr_category[3], curr_category[4]]
    when ((curr_category + criteria_value_names[service_category.id][:rouming] + criteria_value_names[service_category.id][:geo]) == 
      (prev_category + criteria_value_names[prev_service_category.id][:rouming] + criteria_value_names[prev_service_category.id][:geo]))
      i = 2
      [nil, nil, nil, nil, nil]
    when (prev_service_category and (curr_category[0..2] + [curr_category[4]] + criteria_value_names[service_category.id][:rouming] + criteria_value_names[service_category.id][:geo] == 
         prev_category[0..2] + [prev_category[4]] + criteria_value_names[prev_service_category.id][:rouming] + criteria_value_names[prev_service_category.id][:geo]))
         i = 3
      [nil, nil, nil, curr_category[3], curr_category[4]]
    when (prev_service_category and (curr_category[0..1] + [curr_category[4]] + criteria_value_names[service_category.id][:rouming] + criteria_value_names[service_category.id][:geo] == 
      prev_category[0..1] + [prev_category[4]] + criteria_value_names[prev_service_category.id][:rouming] + criteria_value_names[prev_service_category.id][:geo]))
      i = 4
      [nil, nil, curr_category[2], curr_category[3], curr_category[4]]
    when (prev_service_category and ([curr_category[0], curr_category[4]] == [prev_category[0], prev_category[4]]))
      i = 5
      [nil, curr_category[1], curr_category[2], curr_category[3], curr_category[4]]
    when (prev_service_category and curr_category[0] != prev_category[0] and 
        ([curr_category[1], curr_category[4]] + criteria_value_names[service_category.id][:rouming] == 
         [prev_category[1], prev_category[4]] + criteria_value_names[prev_service_category.id][:rouming]) and true)
         i = 6 
      [curr_category[0], curr_category[1], curr_category[2], curr_category[3], curr_category[4]]
    else
      i = 7
      [curr_category[0], curr_category[1], curr_category[2], curr_category[3], curr_category[4]]
    end
    raise(StandardError, [
      i,
      category_items_to_show
    ]) if false and !prev_service_category.nil?
#    category_items_to_show << curr_category[4]
    
    category_items_to_show
  end
  
  def to_compare_format(service_category)
    global_categories = Optimization::Global::Base::CategoryHelper.global_categories_from_uniq_category(service_category.attributes)
    raise(StandardError, [
      service_category
    ]) if false and service_category.id == 314503
    
    global_categories[3][0] = global_categories[3][0] == "in" ? "на" : "кроме" if global_categories[3]
    global_categories[4][0] = global_categories[4][0] == "in" ? "на" : "не на" if global_categories[4] and global_categories[4].try(:[], 2) == 'to_chosen_numbers'
    global_categories[4][0] = global_categories[4][0] == "in" ? "" : "не" if global_categories[4] and global_categories[4].try(:[], 2) == 'internet'

    [
      [service_category.service_category_one_time_id.try(:name), service_category.service_category_periodic_id.try(:name), global_categories[1]].compact[0],
      global_categories[0], global_categories[2], global_categories[3], global_categories[4],
    ]
  end
  
  def geo_presenter(category_group_item, array_of_geo_names = [])
    case 
    when array_of_geo_names.size < 5
      array_of_geo_names.join(", ")
    else
      category_group_item ? show_as_popover(category_group_item, array_of_geo_names.join(", ")) : nil
    end
  end
  
  def show_as_popover(title, content)
    html = {
      :tabindex => "0", 
      :role => "button", 
      :'data-toggle' => "popover", 
      :'data-trigger' => "focus", 
      :'data-placement' => "right",
      :title => title, 
      :'data-content' => content,
      :'data-html' => true
    }
    
    content_tag(:a, html) do
      "#{title} ".html_safe + content_tag(:span, "", {:class => "fa fa-info-circle fa-1x", :'aria-hidden' =>true})
    end
  end   
  
  def criteria_value_names_from_full_category_groups(full_category_groups, m_region)
    category_ids = category_ids_from_full_category_groups(full_category_groups)
    category_names = get_category_names_by_id(category_ids)
    result = {}
    full_category_groups.each do |full_category_group|
      operator_id = full_category_group.tarif_class.operator_id
#      tarif_class_region_id = Category::Region::Const::Alaniya
      tarif_class_region_id = Category::MobileRegions[m_region].try(:[], 'region_ids'). try(:[], 0)
      region_desc = Category::Region::Desc.new(tarif_class_region_id, operator_id)
      
      full_category_group.service_category_tarif_classes.each do |service_category_tarif_class|
        category_ids = Optimization::Global::Base::CategoryHelper.category_ids_from_filtr(service_category_tarif_class.filtr)
        result[service_category_tarif_class.id] ||= {:geo => [], :rouming => [], :operators => []}        

        category_ids.each do |key, category_ids_by_key_1|
          category_ids_by_key = key == :operators ? category_ids_by_key_1 : region_desc.region_ids_by_region_types_or_region_ids(category_ids_by_key_1)
          category_ids_by_key.compact.uniq.map{|id| result[service_category_tarif_class.id][key] << (category_names[id] || category_names[id.to_s]) }
        end
      end
    end    
    result
  end
  
  def category_ids_from_full_category_groups(full_category_groups)
    category_ids = []    
    full_category_groups.each do |full_category_group|
      operator_id = full_category_group.tarif_class.operator_id
      tarif_class_region_id = Category::Region::Const::Alaniya
      region_desc = Category::Region::Desc.new(tarif_class_region_id, operator_id)
      
      full_category_group.service_category_tarif_classes.each do |sc|
        (sc.filtr.try(:values) || []).each do |filtr_value|
          filtr_category_ids = filtr_value["in"] || filtr_value["not_in"]
          next if filtr_category_ids.blank?
          category_ids += (region_desc.region_ids_by_region_types_or_region_ids(filtr_category_ids) - category_ids)
        end
      end
    end
    category_ids
  end
  
  def get_category_names_by_id(category_ids)
    result = {}
    ::Category.select(:id, :name).where(:id => category_ids.uniq).each do |category|
      result[category.id] = category.name
    end
    result
  end
  
  def price_presenter(formula, service_category)
    window_over = case formula.formula['window_over']
    when 'day'; 'день';
    when 'week'; 'неделя';
    else 'месяц'
    end
    group_by = formula.formula['auto_turbo_buttons'].try(:group_by) == 'day' ? 'день' : 'месяц'
    group_by = formula.formula['multiple_use_of_tarif_option'].try(:group_by) == 'day' ? 'день' : 'месяц' if !group_by
    sms_mms_name = ['sms_in', 'sms_out'].include?((service_category.uniq_service_category || "").split('/')[1]) ? "смс" : "ммс"
    
    case formula.standard_formula_id
    when Price::StandardFormula::Const::PriceByMonth
      "#{formula.formula['params']['price']} руб / месяц"
    when Price::StandardFormula::Const::PriceByDay
      "#{formula.formula['params']['price']} руб / день"
    when Price::StandardFormula::Const::PriceByItem
      "#{formula.formula['params']['price']} руб за подключение"
    when Price::StandardFormula::Const::PriceBySumDurationSecond
      "#{formula.formula['params']['price']} руб / секунда"
    when Price::StandardFormula::Const::PriceByCountVolumeItem
      "#{formula.formula['params']['price']} руб / #{sms_mms_name}"
    when Price::StandardFormula::Const::PriceBySumVolumeMByte
      "#{formula.formula['params']['price']} руб / Мб"
    when Price::StandardFormula::Const::PriceBySumVolumeKByte
      "#{formula.formula['params']['price']} руб / Кб"
    when Price::StandardFormula::Const::PriceBySumDuration
      "#{formula.formula['params']['price']} руб / минута"
    when Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, Price::StandardFormula::Const::FixedPriceIfUsedInOneDayVolume, Price::StandardFormula::Const::FixedPriceIfUsedInOneDayAny
      if service_category.service_category_periodic_id
        "#{formula.formula['params']['price']} руб / день*"
      else
        "#{formula.formula['params']['price']} руб / день*"
      end
    when Price::StandardFormula::Const::PriceByMonthIfUsed
      "#{formula.formula['params']['price']} руб / месяц*"
    when Price::StandardFormula::Const::PriceByItemIfUsed
      if service_category.service_category_one_time_id
        "#{formula.formula['params']['price']} руб за подключение"
      else
#        "Стоимость составляет #{formula.formula['params']['price']} руб/месяц, если опция использовалась."
        "#{formula.formula['params']['price']} руб / месяц*"
      end
    when Price::StandardFormula::Const::MaxDurationMinuteForFixedPrice      
      if formula.formula['params']['price'] > 0.0
#        "Стоимость оплаченных #{formula.formula['params']['max_duration_minute']} минут составляет #{formula.formula['params']['price']} руб. в #{window_over}"
        "#{formula.formula['params']['max_duration_minute']} минут за #{formula.formula['params']['price']} руб / #{window_over}"
      else
#        "Включены в абонентскую плату #{formula.formula['params']['max_duration_minute']} минут в #{window_over}"
        "#{formula.formula['params']['max_duration_minute']} минут / #{window_over}"
      end      
    when Price::StandardFormula::Const::MaxCountVolumeForFixedPrice      
      if formula.formula['params']['price'] > 0.0
#        "Стоимость оплаченных #{formula.formula['params']['max_count_volume']} #{sms_mms_name} составляет #{formula.formula['params']['price']} руб. в #{window_over}"
        "#{formula.formula['params']['max_count_volume']} #{sms_mms_name} за #{formula.formula['params']['price']} руб / #{window_over}"
      else
#        "Включены в абонентскую плату #{formula.formula['params']['max_count_volume']} #{sms_mms_name} в #{window_over}"
        "#{formula.formula['params']['max_count_volume']} #{sms_mms_name} / #{window_over}"
      end      
    when Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPrice      
      if formula.formula['params']['price'] > 0.0
#        "Стоимость оплаченных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб. в #{window_over}"
        "#{formula.formula['params']['max_sum_volume']} Мб за #{formula.formula['params']['price']} руб / #{window_over}"
      else
#        "Включены в абонентскую плату #{formula.formula['params']['max_sum_volume']} Мб в #{window_over}"
        "#{formula.formula['params']['max_sum_volume']} Мб / #{window_over}"
      end      
    when Price::StandardFormula::Const::MaxDurationMinuteForFixedPriceIfUsed      
      if formula.formula['params']['price'] > 0.0
#        "Стоимость оплаченных #{formula.formula['params']['max_duration_minute']} минут составляет #{formula.formula['params']['price']} руб. в #{window_over}, если услуга использовалась."
        "#{formula.formula['params']['max_duration_minute']} минут за #{formula.formula['params']['price']} руб / #{window_over}*"
      else
#        "Включены в абонентскую плату #{formula.formula['params']['max_duration_minute']} минут в #{window_over}, если услуга использовалась."
        "#{formula.formula['params']['max_duration_minute']} минут / #{window_over}*"
      end      
    when Price::StandardFormula::Const::MaxCountVolumeForFixedPriceIfUsed      
      if formula.formula['params']['price'] > 0.0
#        "Стоимость оплаченных #{formula.formula['params']['max_count_volume']} #{sms_mms_name} составляет #{formula.formula['params']['price']} руб. в #{window_over}, если услуга использовалась."
        "#{formula.formula['params']['max_count_volume']} #{sms_mms_name} за #{formula.formula['params']['price']} руб / #{window_over}*"
      else
#        "Включены в абонентскую плату #{formula.formula['params']['max_count_volume']} #{sms_mms_name} в #{window_over}, если услуга использовалась."
        "#{formula.formula['params']['max_count_volume']} #{sms_mms_name} в #{window_over}*"
      end      
    when Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed      
      if formula.formula['params']['price'] > 0.0
#        "Стоимость оплаченных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб. в #{window_over}, если услуга использовалась."
        "#{formula.formula['params']['max_sum_volume']} Мб за #{formula.formula['params']['price']} руб / #{window_over}*"
      else
#        "Включены в абонентскую плату #{formula.formula['params']['max_sum_volume']} Мб в #{window_over}, если услуга использовалась."
        "#{formula.formula['params']['max_sum_volume']} Мб в #{window_over}*"
      end      
    when Price::StandardFormula::Const::MaxDurationMinuteForSpecialPrice
#      "Стоимость оплаченных #{formula.formula['params']['max_duration_minute']} минут составляет #{formula.formula['params']['price']} руб. за минуту"
      "#{formula.formula['params']['max_duration_minute']} минут по #{formula.formula['params']['price']} руб / минута"
    when Price::StandardFormula::Const::MaxCountVolumeForSpecialPrice
#      "Стоимость оплаченных #{formula.formula['params']['max_count_volume']} шт. составляет #{formula.formula['params']['price']} руб. за #{sms_mms_name}"
      "#{formula.formula['params']['max_count_volume']} шт. по #{formula.formula['params']['price']} руб / #{sms_mms_name}"
    when Price::StandardFormula::Const::MaxSumVolumeMByteForSpecialPrice
#      "Стоимость оплаченных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб. за Мб"
      "#{formula.formula['params']['max_sum_volume']} Мб по #{formula.formula['params']['price']} руб / Мб"
    when Price::StandardFormula::Const::TurbobuttonMByteForFixedPrice
#      "Стоимость дополнительных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб."
      "#{formula.formula['params']['max_sum_volume']} Мб за #{formula.formula['params']['price']} руб."
    when Price::StandardFormula::Const::TurbobuttonMByteForFixedPriceDay
#      "Стоимость дополнительных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб.. Трафик доступен в течении суток."
      "#{formula.formula['params']['max_sum_volume']} Мб за #{formula.formula['params']['price']} руб / сутки"
    when Price::StandardFormula::Const::MaxCountVolumeWithMultipleUseMonth
#      "Стоимость каждых дополнительных #{formula.formula['params']['max_count_volume']} #{sms_mms_name} составляет #{formula.formula['params']['price']} руб."
      "#{formula.formula['params']['max_count_volume']} #{sms_mms_name} за #{formula.formula['params']['price']} руб."
    when Price::StandardFormula::Const::MaxCountVolumeWithMultipleUseDay
#      "Стоимость каждых дополнительных #{formula.formula['params']['max_count_volume']} #{sms_mms_name}. составляет #{formula.formula['params']['price']} руб. Объем доступен в течении суток."
      "#{formula.formula['params']['max_count_volume']} #{sms_mms_name}. за #{formula.formula['params']['price']} руб / сутки"
    when Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseMonth
#      "Стоимость каждых дополнительных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб."
      "#{formula.formula['params']['max_sum_volume']} Мб за #{formula.formula['params']['price']} руб."
    when Price::StandardFormula::Const::MaxSumVolumeMByteWithMultipleUseDay
#      "Стоимость каждых дополнительных #{formula.formula['params']['max_sum_volume']} Мб составляет #{formula.formula['params']['price']} руб.. Трафик доступен в течении суток."
      "#{formula.formula['params']['max_sum_volume']} Мб за #{formula.formula['params']['price']} руб / сутки"
    when Price::StandardFormula::Const::TwoStepPriceMaxDurationMinute
      "Первые#{formula.formula['params']['duration_minute_1']} мин - #{formula.formula['params']['price_0']} руб / мин,
       потом - #{formula.formula['params']['price_1']} руб. за минуту. 
       Цены действуют для первых #{formula.formula['params']['max_duration_minute']} мин/#{window_over}."
    when Price::StandardFormula::Const::TwoStepPriceDurationMinute
      "Первые #{formula.formula['params']['duration_minute_1']} мин - #{formula.formula['params']['price_0']} руб / мин, 
       потом - #{formula.formula['params']['price_1']} руб / мин."
    when Price::StandardFormula::Const::ThreeStepPriceDurationMinute
      "Первые #{formula.formula['params']['duration_minute_1']} мин - #{formula.formula['params']['price_0']} руб / мин,
       между #{formula.formula['params']['duration_minute_1']} и #{formula.formula['params']['duration_minute_2']} мин - #{formula.formula['params']['price_1']} руб/мин, 
       потом - #{formula.formula['params']['price_2']} руб / мин."
    else
      content_tag(:div, :style => "display: table-row;") do
        content_tag(:div, formula.attributes, :style => "display: table-cell; padding-left: 1px; padding-top: 5px;") +
        content_tag(:div, formula.standard_formula.attributes, :style => "display: table-cell; padding-left: 1px; padding-top: 5px;")
      end
    end
  end
  
  def show_asterics_for_formula_details(formula_ids)
    possible_asterics = [
      {tag: "*", comment: "если услуга использовалась.", formula_ids: [
        Price::StandardFormula::Const::FixedPriceIfUsedInOneDayDuration, Price::StandardFormula::Const::FixedPriceIfUsedInOneDayVolume, Price::StandardFormula::Const::FixedPriceIfUsedInOneDayAny,
        Price::StandardFormula::Const::PriceByMonthIfUsed, Price::StandardFormula::Const::PriceByItemIfUsed, Price::StandardFormula::Const::MaxDurationMinuteForFixedPriceIfUsed,
        Price::StandardFormula::Const::MaxCountVolumeForFixedPriceIfUsed, Price::StandardFormula::Const::MaxSumVolumeMByteForFixedPriceIfUsed,        
      ]},
    ]
    possible_asterics.select{|possible_asteric| !(possible_asteric[:formula_ids] & formula_ids).blank? }
  end

end

