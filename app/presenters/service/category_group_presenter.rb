class Service::CategoryGroupPresenter
  include Service::CategoryTarifClassPresenter
  extend Service::CategoryTarifClassPresenter
  
  ReportStructure = {
    :fixed => {:name => "Разовые или постоянные платежи", :base => :fixed, :additional => [], :excuded_name => nil, :hide_item_heads => true, :hide_table_heads => true},
    :included_in_tarif => {:name => " Предоплаченные объемы услуг", :base => :included_in_tarif, :additional => [], :excuded_name => "собственный и домашний регион"},

    :home_and_own_regions_rouming_calls => {:name => "Домашний регион, звонки", :base => :others, :additional => [:home_and_own_regions_rouming, :calls], :excuded_name => "домашний регион"},
    :home_and_own_regions_rouming_internet => {:name => "Домашний регион, интернет", :base => :others, :additional => [:home_and_own_regions_rouming, :internet], :excuded_name => "домашний регион"},
    :home_and_own_regions_rouming_sms => {:name => "Домашний регион,  смс", :base => :others, :additional => [:home_and_own_regions_rouming, :sms], :excuded_name => "домашний регион"},
    :home_and_own_regions_rouming_mms => {:name => "Домашний регион, ммс", :base => :others, :additional => [:home_and_own_regions_rouming, :mms], :excuded_name => "домашний регион"},

    :own_country_rouming_calls => {:name => "Путешествую по стране, звонки", :base => :others, :additional => [:own_country_rouming, :calls], :excuded_name => "Россия"},
    :own_country_rouming_internet => {:name => "Путешествую по стране, интернет", :base => :others, :additional => [:own_country_rouming, :internet], :excuded_name => "Россия"},
    :own_country_rouming_sms => {:name => "Путешествую по стране,  смс", :base => :others, :additional => [:own_country_rouming, :sms], :excuded_name => "Россия"},
    :own_country_rouming_mms => {:name => "Путешествую по стране, ммс", :base => :others, :additional => [:own_country_rouming, :mms], :excuded_name => "Россия"},

    :international_rouming_calls => {:name => "Международный роуминг, звонки", :base => :others, :additional => [:international_rouming, :calls], :excuded_name => "международный роуминг"},
    :international_rouming_internet => {:name => "Международный роуминг, интернет", :base => :others, :additional => [:international_rouming, :internet], :excuded_name => "международный роуминг"},
    :international_rouming_sms => {:name => "Международный роуминг,  смс", :base => :others, :additional => [:international_rouming, :sms], :excuded_name => "международный роуминг"},
    :international_rouming_mms => {:name => "Международный роуминг, ммс", :base => :others, :additional => [:international_rouming, :mms], :excuded_name => "международный роуминг"},
  }
  ReportStructureForRegionFiltr = {
    :fixed => {:name => "Разовые или постоянные платежи", :base => :fixed, :additional => [], :excuded_name => nil, :hide_item_heads => true, :hide_table_heads => true},
    :included_in_tarif => {:name => " Предоплаченные объемы услуг", :base => :included_in_tarif, :additional => [], :excuded_name => "собственный и домашний регион"},
    :filtred_by_regions => {:name => "Отфильтрованные значения", :base => :others, :additional => [], :excuded_name => nil, :hide_item_heads => false, :hide_table_heads => false},
  }

  #Service::CategoryGroupPresenter.free_calls_in_tarif([201])
  def self.free_calls_in_tarif(tarif_class_ids, m_region = 'moskva_i_oblast')
    result = {}
    operator_name_list = {}
    Category::Operator.all.each{|operator| operator_name_list[operator.id] = operator.name}
    (category_groups_by_types(tarif_class_ids, m_region, :others, [:home_and_own_regions_rouming, :calls_out, :zero_variable_price]) + 
      category_groups_by_types(tarif_class_ids, m_region, :others, [:own_country_rouming, :calls_out, :zero_variable_price])).each do |category_group|
      result[category_group.tarif_class_id] ||= []
      category_group.service_category_tarif_classes.each do |sctc| 
        global_categories = Optimization::Global::Base::CategoryHelper.global_categories_from_uniq_category(sctc.attributes)
        
        if global_categories[3] and !global_categories[3][1].blank?
          operator_names = global_categories[3][1].uniq.map{|operator_id| operator_name_list[operator_id]}  #::Category.select(:id, :name).where(:id => global_categories[3][1].uniq).pluck(:name)
          global_categories[3][0] = global_categories[3][0] == "in" ? "на" : "кроме"
          global_categories[3] = global_categories[3][1].size == 1 ? "#{global_categories[3][0]} своего оператора" : "#{global_categories[3][0]} #{operator_names.join(', ')}"               
        end
        
        global_categories = global_categories.map{|category_name| Optimization::Global::Base::Dictionary.tr(category_name)}
        
        result[category_group.tarif_class_id] << global_categories[1..-1]
      end      
    end
    result
  end

  def self.included_services_in_tarif(tarif_class_ids, m_region = 'moskva_i_oblast')
    result = {}
    category_groups_by_types(tarif_class_ids, m_region, :included_in_tarif).each do |category_group|
      result[category_group.tarif_class_id] ||= {}
      category_group.price_lists.each do |price_list| 
        price_list.formulas.each do |formula|
          params = formula.formula["params"]
          case
          when (params and !params["max_duration_minute"].blank?); result[category_group.tarif_class_id][:max_duration_minute] = params.try(:[], "max_duration_minute")
          when (params and !params["max_count_volume"].blank?); result[category_group.tarif_class_id][:max_count_volume] = params["max_count_volume"]
          when (params and !params["max_sum_volume"].blank?); result[category_group.tarif_class_id][:max_sum_volume] = params["max_sum_volume"]
          end
        end
      end      
    end
    result
  end
  
  def self.report_structure(with_region_filtr = false)
    with_region_filtr ? ReportStructureForRegionFiltr : ReportStructure
  end
  
  def self.item_categories(tarif_class_id_to_show, support_service_id, m_region, expand_all, filtred_regions, chosen_support_service_ids)
    use_condensed_report_structure = (!filtred_regions.blank? or !chosen_support_service_ids.blank?)
    report_structure = report_structure(use_condensed_report_structure)
    item_categories = {}; 
    show_unpaid_services_section_title = false 
    items_to_show = 0; prev_expand_value = "true" 
    max_open_items = (expand_all == "true" ? 200 : 3) 
    expand_all_button_is_not_yet_shown = true 
    
    all_category_groups_by_types(tarif_class_id_to_show, support_service_id, m_region, use_condensed_report_structure, chosen_support_service_ids).
      each_with_index do |(report_group, full_category_groups), index|
      
      item_categories[report_group] = category_groups_presenter(full_category_groups, m_region, filtred_regions)
      
      item_categories[report_group][:hide_item_heads] = report_structure[report_group.to_sym][:hide_item_heads]
      item_categories[report_group][:name] = report_structure[report_group.to_sym][:name]
      item_categories[report_group][:excuded_name] = report_structure[report_group.to_sym][:excuded_name]
      item_categories[report_group][:hide_table_heads] = report_structure[report_group.to_sym][:hide_table_heads]
  
      next if item_categories[report_group].try(:[], :result).blank?
      
      if (index > max_open_items and items_to_show > max_open_items) 
        item_categories[report_group][:expanded] = "false"
        item_categories[report_group][:expanded_class] = "collapse"
      else
        item_categories[report_group][:expanded] = "true"
        item_categories[report_group][:expanded_class] = "collapse in"
        items_to_show += 1
      end
      
      item_categories[report_group][:show_unpaid_services_section_title] = false    
      if show_unpaid_services_section_title
        show_unpaid_services_section_title = false
        item_categories[report_group][:show_unpaid_services_section_title] = true
      end   
      
      if report_group.to_sym == :included_in_tarif
        show_unpaid_services_section_title = true
        item_categories[report_group][:show_unpaid_services_section_title] = false
      end    
          
      item_categories[report_group][:expand_all_button_is_not_yet_shown] = expand_all_button_is_not_yet_shown ? true : false
  
      if expand_all == 'false' and  item_categories[report_group][:expanded] == 'false' and expand_all_button_is_not_yet_shown
        expand_all_button_is_not_yet_shown = false
      end
      
    end
    item_categories  
  end
  
  def self.all_category_groups_by_types(tarif_class_id_to_show, support_service_id, m_region = 'moskva_i_oblast', with_region_filtr = false, chosen_support_service_ids = [])
    result = {}    
    report_structure(with_region_filtr).each do |report_group, details|
      category_groups_by_types(tarif_class_id_to_show, m_region, details[:base], details[:additional], support_service_id, report_group, chosen_support_service_ids).each do |item|
        result[report_group] ||= []
        result[report_group] << item
      end
    end
    result
  end
  
  def self.category_groups_by_types(tarif_class_ids_input, m_region = 'moskva_i_oblast', 
      filtr = :fixed, additional_filtr_keys = [], support_service_id = nil, report_group = 'no_group', chosen_support_service_ids = [])  
      
    additional_from = support_service_id ? ", json_array_elements((service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options')) as support_service_id" : ""
    Service::CategoryGroup.
      select("'#{report_group.to_s}' as report_group").
      includes(:tarif_class, service_category_tarif_classes: [:service_category_one_time, :service_category_periodic]).
      includes(price_lists: [formulas: [:standard_formula]]).references(:price_formulas).
      joins(additional_from).
      joins(", regexp_split_to_array(service_category_tarif_classes.uniq_service_category, '/') as gl_cat").
      where(filtr_condition(tarif_class_ids_input, filtr, additional_filtr_keys, support_service_id, chosen_support_service_ids, m_region)).
#      where(:tarif_class_id => (params[:id] || session[:current_id]['tarif_class_id'])).
      order("service_category_tarif_classes.service_category_one_time_id").
      order("service_category_tarif_classes.service_category_periodic_id").
      order("gl_cat[2], gl_cat[1], gl_cat[3], gl_cat[4]").
      order("service_category_tarif_classes.uniq_service_category").
      order("price_formulas.calculation_order") 
  end
  
  def self.filtr_condition(tarif_class_ids_input, filtr = :fixed, additional_filtr_keys = [], support_service_id = nil, chosen_support_service_ids = [], m_region = 'moskva_i_oblast')
    base_filtr = base_filtr_condition(tarif_class_ids_input, support_service_id, chosen_support_service_ids, m_region)

    fixed_filtr = "service_category_tarif_classes.service_category_one_time_id is not null or service_category_tarif_classes.service_category_periodic_id is not null"
    included_in_tarif = "price_formulas.standard_formula_id = any('{#{Price::StandardFormula::Const::MaxVolumesForFixedPriceConst.join(', ')}}')" 
    home_calls_and_internet = "service_category_tarif_classes.uniq_service_category SIMILAR TO 'own_and_home_regions/(calls_out/to_own_and_home_regions|internet)%'"
    
    base = {}
    base[:home_and_own_regions_rouming] = "service_category_tarif_classes.uniq_service_category SIMILAR TO 'own_and_home_regions%'"
    base[:own_country_rouming] = "service_category_tarif_classes.uniq_service_category SIMILAR TO 'own_country_regions%'"
    base[:international_rouming] = "service_category_tarif_classes.uniq_service_category SIMILAR TO 'abroad_countries%'"
    
    base[:calls] = "service_category_tarif_classes.uniq_service_category SIMILAR TO '%(calls_in|calls_out)%'"
    base[:calls_out] = "service_category_tarif_classes.uniq_service_category SIMILAR TO '%calls_out%'"
    base[:sms] = "service_category_tarif_classes.uniq_service_category SIMILAR TO '%(sms_in|sms_out)%'"
    base[:mms] = "service_category_tarif_classes.uniq_service_category SIMILAR TO '%(mms_in|mms_out)%'"
    base[:internet] = "service_category_tarif_classes.uniq_service_category SIMILAR TO '%internet%'"

    base[:zero_variable_price] = "price_formulas.standard_formula_id = any('{#{Price::StandardFormula::Const::PriceBySomeVolumeConst.join(', ')}}') and \
      (price_formulas.formula#>>'{params, price}')::numeric = 0.0"
    result = case filtr
    when :fixed
      [base_filtr, fixed_filtr]
    when :included_in_tarif
      [base_filtr, "not (#{fixed_filtr})",included_in_tarif]
    when :others
      [base_filtr, "not (#{fixed_filtr})", "not (#{included_in_tarif})"]
    when :home_calls_and_internet
      [base_filtr, home_calls_and_internet, "not (#{fixed_filtr})", "not (#{included_in_tarif})"]
    else
      [base_filtr]
    end

    additional_filtr_keys.map{|key| result << base[key]}

    result.map{|f| "( #{f} )"}.join(" and ")
  end

  def self.base_filtr_condition(tarif_class_ids_input, support_service_id = nil, chosen_support_service_ids = [], m_region = 'moskva_i_oblast')
    tarif_class_ids = !tarif_class_ids_input.is_a?(Array) ? [tarif_class_ids_input] : tarif_class_ids_input
    tarif_where_hash = "service_category_groups.tarif_class_id = any('{ #{tarif_class_ids.join(', ')} }')" 
    region_id = Category::MobileRegions[m_region].try(:[], 'region_ids'). try(:[], 0)
    
    support_service_where_hash = support_service_id.blank? ? "true" : "support_service_id::text::integer = #{support_service_id}" 
      
    tarif_set_must_include_tarif_options_is_null = "(service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::jsonb is null"
    tarif_set_must_include_tarif_options_is_blank = "service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options' = '[]'"
    tarif_set_must_include_tarif_options_is_in_array = 
      "ARRAY(SELECT json_array_elements_text( service_category_tarif_classes.conditions#>'{tarif_set_must_include_tarif_options}' ) as s order by s) <@ '{ #{chosen_support_service_ids.sort.join(', ')} }'"

    chosen_support_service_where_hash = chosen_support_service_ids.blank? ? "#{tarif_set_must_include_tarif_options_is_null} or #{tarif_set_must_include_tarif_options_is_blank}" :
    "(#{tarif_set_must_include_tarif_options_is_in_array}) and json_array_length(service_category_tarif_classes.conditions#>'{tarif_set_must_include_tarif_options}') > 0"    
      
    region_sql = "( #{TarifClass.regions_sql(region_id)} ) and ( #{Price::Formula.regions_sql(region_id)} ) and ( #{Service::CategoryTarifClass.regions_sql(region_id)} )"

    "( #{tarif_where_hash} ) and ( #{support_service_where_hash} ) and ( #{chosen_support_service_where_hash} ) and ( #{region_sql} )"
  end

end

