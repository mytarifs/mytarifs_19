# == Schema Information
#
# Table name: tarif_classes
#
#  id                  :integer          not null, primary key
#  name                :string
#  operator_id         :integer
#  privacy_id          :integer
#  standard_service_id :integer
#  features            :json
#  description         :text
#  created_at          :datetime
#  updated_at          :datetime
#  dependency          :json
#  slug                :string
#

class TarifClass < ActiveRecord::Base
  ServiceType = {:tarif => 40, :common_service => 41, :special_service => 42, :option_of_tarif => 43}
  
  include WhereHelper, FriendlyIdHelper
#  extend FriendlyId

  store_accessor :features, :http, :buy_http, :payment_type, :phone_number_type, :allowed_option_for_children, :tv_video_content, :contract_sharing_with_other_devices,
                            :phone_must_have_3g_or_4g, :only_mobile_phone, :limited_trafic_to_file_nets, :recommended_for_planshet, :limited_speed, :limited_time_of_day, 
                            :internet_sharing_with_other_devices, :available_only_for_pencioner, :region_txt, :publication_status, :excluded_from_optimization,
                            :for_parsing, :search_services_tag, :has_parsing_class, :parsing_class, :services_to_skip_scrap, :services_to_force_scrap, :for_existing_servises,
                            :secondary_tarif_class, :parse_params,
                            :regions, :archived_regions
  store_accessor :dependency, :incompatibility, :general_priority, :other_tarif_priority, :prerequisites, :forbidden_tarifs, :multiple_use, :is_archived, :parts
                              

  friendly_id :slug_candidates, use: [:slugged]#, :finders]
  
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id
  belongs_to :privacy, :class_name =>'Category', :foreign_key => :privacy_id
  belongs_to :standard_service, :class_name =>'Category', :foreign_key => :standard_service_id
  has_many :service_category_tarif_classes, :class_name => 'Service::CategoryTarifClass', :foreign_key => :tarif_class_id
  has_many :tarif_lists, :class_name => 'TarifList', :foreign_key => :tarif_class_id, :dependent => :destroy
  has_many :service_category_groups, :class_name =>'Service::CategoryGroup', :foreign_key => :tarif_class_id, :dependent => :destroy

  scope :for_business, -> {where(:privacy_id => 1)}
  scope :for_private_use, -> {where(:privacy_id => 2)}

  scope :tarifs, -> {where(:standard_service_id => 40)}
  scope :common_services, -> {where(:standard_service_id => 41)}
  scope :special_services, -> {where(:standard_service_id => 42)}
  scope :special_and_common_services, -> {where(:standard_service_id => [41, 42])}
  scope :options_of_tarif, -> {where(:standard_service_id => 43)}

  #TarifClass.check_tarif_class_id_in_service_category_tarif_classes
  def self.check_tarif_class_id_in_service_category_tarif_classes
    result = {}
    joins(service_category_groups: :service_category_tarif_classes).where("tarif_classes.id != service_category_tarif_classes.tarif_class_id").
      order("tarif_classes.operator_id").
      select("tarif_classes.id, tarif_classes.name, tarif_classes.operator_id").each do |item|
        result[item['operator_id']] ||= {}
        result[item['operator_id']][item['id']] = item['name']
    end
    result
  end
    
  #TarifClass.check_tarif_class_id_in_service_category_groups
  def self.check_tarif_class_id_in_service_category_groups
    joins(:service_category_groups).where("tarif_classes.id != service_category_groups.tarif_class_id").pluck("tarif_classes.id")
  end
    
  def default_name
    case id
    when 681; 'moy_beeline'
    when 682; 'moy_beeline_postoplatnaya'
    else name
    end
  end
  
  def slug_candidates
    [
      :default_name,
      [:privacy_name_for_slug, :default_name],
      [:privacy_name_for_slug, :region_txt, :default_name],
      [:privacy_name_for_slug, :region_txt, :standard_service_name, :default_name],
      [:operator_name, :privacy_name_for_slug, :region_txt, :standard_service_name, :default_name],
    ]
  end
  
  def operator_name
    operator.name if operator_id
  end    
  
  def privacy_name_for_slug
    privacy_id == 1 ? "dlya_biznesa" : "dly_chastnih_clientov"
  end    
  
  def standard_service_name
    standard_service.name if standard_service_id
  end

  def full_name
    "#{operator_name} #{name}"
  end

  def default_region_txt
    c = Category::Region::Const
    if regions.blank?
      features.try(:[], 'region_txt').blank? ? Category::Region::Desc::Const[c::Moskva]['mobile_region_slug'] : features.try(:[], 'region_txt')
      
    else
      main_regions = [c::Moskva, c::Sankt_peterburg] & regions
      case
      when !main_regions.blank?
        Category::Region::Desc::Const[main_regions[0]]['mobile_region_slug']
      else
        Category::Region::Desc::Const[regions[-1]]['mobile_region_slug']
      end
    end     
  end
  
  def default_region_txt_for_secondary
    features.try(:[], 'region_txt').blank? ? default_region_txt : features.try(:[], 'region_txt') 
  end
  
  def name_with_region
    region_txt.blank? ? "#{name}" : "#{name} - #{Category::MobileRegions[region_txt].try(:[], 'name')}"
  end
  
  def full_name_with_region
    region_txt.blank? ? "#{full_name}" : "#{full_name} - #{Category::MobileRegions[region_txt].try(:[], 'name')}"
  end
  
  def full_http_from_http(m_region, http_field = :http)  
    http_to_use = send(http_field.to_sym)  
    return http_to_use if http_to_use.blank?
    m_region_to_use = m_region || default_region_txt
    region_id = Category::MobileRegions[m_region_to_use].try(:[], 'region_ids'). try(:[], 0)
    parser = ServiceParser::Runner.init({
      :operator_id => operator_id,
      :region_id => region_id,
    })
    url_without_domen = parser.url_without_domain(http_to_use)
    parser.add_domain(url_without_domen, region_id, privacy_id)
  end
  
  def self.servce_ids_for_calculations(service_type_id, privacy_id = 2, region_txt = 'moskva_i_oblast')    
    result = {}
    
    Category::Operator::Const::OperatorsForOptimization.each{|operator_id| result[operator_id] = []}
    
    select("operator_id, array_agg(distinct id) as tarifs").
      where(:standard_service_id => service_type_id).
      where(:operator_id => Category::Operator::Const::OperatorsForOptimization).
      where(:privacy_id => privacy_id).
      region_txt(region_txt).
      service_is_not_excluded_from_optimization.
      service_is_published.service_is_not_archived.
      for_parsing('false').
      original_tarif_class.
      group(:operator_id).
      each do |item|
        result[item.operator_id] = item.tarifs
    end
    result  
  end  

  #TarifClass.tarif_option_ids_for_calculations_by_type
  def self.tarif_option_ids_for_calculations_by_type(privacy_id = 2, region_txt = 'moskva_i_oblast')    
    result = {}

    Category::Operator::Const::OperatorsForOptimization.each do |operator_id| 
      result[operator_id] ||= {}
      [:international_rouming, :country_rouming, :mms, :sms, :internet, :calls].each{|type| result[operator_id][type] = []}
    end
    
    where(:operator_id => Category::Operator::Const::OperatorsForOptimization).
      where(:privacy_id => privacy_id).region_txt(region_txt).service_is_not_excluded_from_optimization.
      service_is_published.service_is_not_archived.original_tarif_class.for_parsing('false').
      by_global_part.each do |item|
        next if item.standard_service_id != ServiceType[:special_service]
        tarif_option_part = tarif_option_part_by_global_part(item.global_parts)
        result[item.operator_id][tarif_option_part] << item.tarif_class_id if tarif_option_part
    end
    result
  end

  def self.tarif_option_part_by_global_part(global_parts)
    case
    when global_parts.include?("abroad_countries")
      :international_rouming
    when (global_parts.include?("own_country_regions") and !global_parts.include?("own_and_home_regions"))
      :country_rouming
    when global_parts.include?("internet")
      :internet
    when !(global_parts & ['calls_in', 'calls_out']).blank?
      :calls
    when !(global_parts & ['sms_in', 'sms_out']).blank?
      :sms
    when !(global_parts & ['mms_in', 'mms_out']).blank?
      :mms
    else
      nil
    end
  end
  
  #TarifClass.service_ids_by_service_categories
  def self.service_ids_by_service_categories(privacy_id = 2, region_txt = 'moskva_i_oblast', operator_ids = Category::Operator::Const::OperatorsForOptimization)
    special_and_common_services_ids = [:common_service, :special_service].map{|t| ServiceType[t]}
    where(:operator_id => operator_ids).
      where(:privacy_id => privacy_id).region_txt(region_txt).service_is_not_excluded_from_optimization.
      service_is_published.service_is_not_archived.to_service_categories(special_and_common_services_ids).
      original_tarif_class
  end

  def self.to_service_categories(limited_by_standard_service_id = nil)
    result = {}
    self.by_global_part.each do |item|
      service_categories = service_categories_from_global_part(item.global_parts)  
      service_categories[:service_category].each do |service_category|
        service_categories[:service_type].each do |service_type|
          next if limited_by_standard_service_id and !limited_by_standard_service_id.include?(item.standard_service_id)
          next if item.is_support and [:service_to_abroad, :service_to_other_regions].include?(service_category)
          result[service_category] ||= {}
          result[service_category][service_type] ||= []
          result[service_category][service_type] << item.tarif_class_id            
        end
        result[service_category][:all_service_types] = result[service_category].values.flatten.uniq if result[service_category]
      end
    end
    result
  end
  
  def self.by_global_part
    direct_tarifs_sql = select("tarif_classes.operator_id, tarif_classes.id as tarif_class_id, array_agg(distinct global_part) as global_parts, \
    tarif_classes.standard_service_id, false as is_support").
      joins(service_category_groups: :service_category_tarif_classes).
      joins(", regexp_split_to_table(uniq_service_category, '/') as global_part").
      group("tarif_classes.operator_id, tarif_classes.id, tarif_classes.standard_service_id, is_support").to_sql

    allowed_tarif_ids = self.pluck(:id)

    support_tarifs_sql = unscope(:where).
      select("tarif_classes_1.operator_id, support_service_id::text::integer as tarif_class_id, array_agg(distinct global_part) as global_parts, \
      tarif_classes_1.standard_service_id, true as is_support").
      joins(service_category_groups: :service_category_tarif_classes).
      joins(", regexp_split_to_table(uniq_service_category, '/') as global_part").
      joins(", json_array_elements((service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options')) as support_service_id").
      joins("inner join tarif_classes tarif_classes_1 on tarif_classes_1.id = support_service_id::text::integer").
      where("support_service_id::text::integer = any('{#{allowed_tarif_ids.join(', ')}}')")
    support_tarifs_sql = support_tarifs_sql.where(:tarif_classes => {:id => allowed_tarif_ids}) if allowed_tarif_ids.size > 1
    support_tarifs_sql = support_tarifs_sql.
      group("tarif_classes_1.operator_id, support_service_id::text::integer, tarif_classes_1.standard_service_id, is_support").to_sql

    final_sql = "#{(direct_tarifs_sql)} union #{support_tarifs_sql}"
    find_by_sql(final_sql)    
  end
  
  def self.service_categories_from_global_part(global_parts)
    result = {:service_category => [], :service_type => []}
    result[:service_category] << :international_rouming if global_parts.include?("abroad_countries")
    result[:service_category] << :country_rouming if (global_parts.include?("own_country_regions") and !global_parts.include?("own_and_home_regions"))
    result[:service_category] << :service_to_abroad if global_parts.include?("own_and_home_regions") and (global_parts.include?("to_abroad_countries") or global_parts.include?("to_abroad"))
    result[:service_category] << :service_to_other_regions if global_parts.include?("own_and_home_regions") and global_parts.include?("to_own_country_regions")

    result[:service_type] << :internet if global_parts.include?("internet")
    result[:service_type] << :calls if !(global_parts & ['calls_in', 'calls_out']).blank?
    result[:service_type] << :sms if !(global_parts & ['sms_in', 'sms_out']).blank?
    result[:service_type] << :mms if !(global_parts & ['mms_in', 'mms_out']).blank?
    
    result
  end
  
  def self.privacy_and_region_where(m_privacy, m_region)
    privacy_id = Category::Privacies[m_privacy].try(:[], 'id')
    where(:privacy_id => privacy_id).region_txt(m_region)
  end

  def self.privacy_and_region_where_with_default(m_privacy, m_region)
    m_privacy_to_use = m_privacy.blank? ? 'personal' : m_privacy
    m_region_to_use = m_region.blank? ? 'moskva_i_oblast' : m_region
    privacy_id = Category::Privacies[m_privacy_to_use].try(:[], 'id')
    where(:privacy_id => privacy_id).region_txt(m_region_to_use)
  end

  def self.regions_sql(regions = [], filtr_type = 'all')
    return "true" if regions.blank?
    regions = [regions] if !regions.is_a?(Array)
    regions = regions.map(&:to_i)
    condition = filtr_type == 'all' ? '@>' : '&&'
    where_string_array = [
        "nullif(tarif_classes.features#>>'{regions}', '[]') is null",
#        "(tarif_classes.features->'regions')::jsonb = '[]'",
        "ARRAY(SELECT json_array_elements_text( tarif_classes.features#>'{regions}' )) #{condition} '{ #{regions.join(', ')} }'",
    ]
    where_string_array.join(' or ')      
  end

  def self.regions(regions = [], filtr_type = 'all')
    where(regions_sql(regions, filtr_type))      
  end

  def self.regions_txt(regions_txt = [])
    regions_txt_to_use = regions_txt || []
    region_ids = regions_txt_to_use.map{|region_txt_to_use| Category::MobileRegions[region_txt_to_use].try(:[], 'region_ids'). try(:[], 0)}.compact.uniq
    region_ids.blank? ? where("false") : regions(region_ids)
  end
  
  def self.region_txt(region_txt = 'moskva_i_oblast')
    region_txt_to_use = region_txt || 'moskva_i_oblast'
    region_id = Category::MobileRegions[region_txt_to_use].try(:[], 'region_ids'). try(:[], 0)
    region_id ? regions(region_id) : where("false")
  end
  
  def self.old_region_txt(region_txt = 'moskva_i_oblast')
    where_sql = region_txt.blank? ? "true" : "(tarif_classes.features->>'region_txt')::text is null or tarif_classes.features->>'region_txt' = '#{region_txt}'"
    where(where_sql)  
  end

  def self.extend_with_regions(region_txt, region_ids_to_use_if_region_txt_blank = nil)
    if region_txt.blank?
      all_region_ids_to_use = region_ids_to_use_if_region_txt_blank || Category::MobileRegions.map{|region_txt, region_desc| region_desc['region_ids'][0]}
      select("json_array_elements_text(COALESCE(nullif(tarif_classes.features#>>'{regions}', '[]')::json, '[#{all_region_ids_to_use.join(', ')}]'))::integer as region_id", "tarif_classes.*")
    else
      region_id = Category::MobileRegions[region_txt].try(:[], 'region_ids'). try(:[], 0)
      if region_id
        select("#{region_id} as region_id", "tarif_classes.*")
      else
        where("false")
      end
    end
  end

  def self.payment_type(payment_type)
    where("tarif_classes.features->>'payment_type' = '#{payment_type}'")
  end

  def self.service_is_published
    where("(tarif_classes.features->>'publication_status')::integer = #{Content::Article::PublishStatus[:published]}")
  end

  def self.is_service_published?(publication_status)
    publication_status = [publication_status] if !publication_status.is_a?(Array)
    publication_status = publication_status.map(&:to_i)
    publication_status.blank? ? where("(tarif_classes.features->>'publication_status')::integer is null or (tarif_classes.features->>'publication_status')::text = ''") :   
      where("(tarif_classes.features->>'publication_status')::integer = any('{#{publication_status.join(', ')} }')")
  end

  def self.service_is_not_archived
    where("(tarif_classes.dependency->>'is_archived')::boolean = false or (tarif_classes.dependency->>'is_archived') is null")
  end

  def self.service_is_not_excluded_from_optimization
    where("(tarif_classes.features->>'excluded_from_optimization')::boolean = false or (tarif_classes.features->>'excluded_from_optimization') is null")
  end
  
  def self.for_parsing(is_for_parsing = 'true')
    [true, 'true'].include?(is_for_parsing) ? 
      where("(tarif_classes.features->>'for_parsing')::boolean = true") :
      where("(tarif_classes.features->>'for_parsing')::boolean = false or (tarif_classes.features->>'for_parsing') is null")
  end
  
  def self.excluded_from_optimization(is_excluded_from_optimization = 'true')
    [true, 'true'].include?(is_excluded_from_optimization) ? 
      where("(tarif_classes.features->>'excluded_from_optimization')::boolean = true") :
      where("(tarif_classes.features->>'excluded_from_optimization')::boolean = false or (tarif_classes.features->>'excluded_from_optimization') is null")
  end
  
  def self.parts(parts = [])
    parts_string = parts.map{|part| "'#{part}'"}.join(", ")
    parts.blank? ? all : joins(", jsonb_array_elements_text((tarif_classes.dependency->'parts')::jsonb) as part").
    where("part::text in ( #{parts_string} )")
  end

  def self.support_services(m_region, base_service_ids = [])
    region_txt_to_use = m_region || 'moskva_i_oblast'
    region_id = Category::MobileRegions[region_txt_to_use].try(:[], 'region_ids'). try(:[], 0)

    model = select("distinct jsonb_array_elements((service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options')::jsonb) as support_service_id").
      joins(service_category_groups: [:service_category_tarif_classes, price_lists: :formulas]).
      where("json_array_length(service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options') > 0").
      where("#{TarifClass.regions_sql(region_id)}").
      where("#{Service::CategoryTarifClass.regions_sql(region_id)}").
      where("#{Price::Formula.regions_sql(region_id)}")
    
    model = model.where(:id => base_service_ids) if !base_service_ids.blank?
    
    support_service_ids_to_use = model.map(&:support_service_id)
    
    TarifClass.unscope(:where).where(:id => support_service_ids_to_use).
      where("#{TarifClass.regions_sql(region_id)}")
  end
  
  def self.support_service_ids(m_region)
    support_services(m_region).map(&:id)
  end
  
  #TarifClass.services_with_support_service(328, nil)
  def self.services_with_support_service(support_service_id, m_region)
    region_txt_to_use = m_region || 'moskva_i_oblast'
    region_id = Category::MobileRegions[region_txt_to_use].try(:[], 'region_ids'). try(:[], 0)

    service_ids = select("distinct tarif_classes.id").
    joins(service_category_groups: [:service_category_tarif_classes, price_lists: :formulas]).
    joins(", json_array_elements((service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options')) as support_service_id").
    joins("left join tarif_classes as support_tarif_classes on support_tarif_classes.id = support_service_id::text::integer").
    where("support_tarif_classes.standard_service_id != ?", TarifClass::ServiceType[:tarif]).
    where("#{TarifClass.regions_sql(region_id)}").
    where("#{Service::CategoryTarifClass.regions_sql(region_id)}").
    where("#{Price::Formula.regions_sql(region_id)}").
    where("support_service_id::text::integer = #{support_service_id}").pluck("id")
    
    where(:id => service_ids)
  end
  
  def self.incombatibility_groups(service_ids)
    select("distinct on (incompatibility.key, incompatibility.value::text) incompatibility.key, incompatibility.value as incompatible_ids").
    joins(", json_each(dependency->'incompatibility') as incompatibility").
    where(:id => service_ids)
  end
  
  #TarifClass.update_support_service_parts
  def self.update_support_service_parts(support_service_ids = [])
    support_service_parts_result = support_service_parts(support_service_ids)
    where(:id => support_service_parts_result.keys).each do |support_service|
      support_service.dependency['parts'] ||= []
      support_service.dependency['parts'] += (support_service_parts_result[support_service.id] - support_service.dependency['parts'])
      support_service.save!
    end
  end
  
  #TarifClass.support_service_parts([9335])
  def self.support_service_parts(support_service_ids = []) 
    result = {}
    first_sql = select("distinct 
            jsonb_array_elements((service_category_tarif_classes.conditions->'parts')::jsonb) as part, \
            jsonb_array_elements((service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options')::jsonb) as support_service_id").
    joins(service_category_groups: :service_category_tarif_classes).
    where("json_array_length(service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options') > 0").to_sql
    
    base_where_hash = support_service_ids.blank? ? "true" : "support_service_id = any('{ #{support_service_ids.join(', ')} }')"
    
    find_by_sql("with support_service_ids as (#{first_sql}) select * from support_service_ids where #{base_where_hash}").
    map do |row| 
      result[row['support_service_id']] ||= []
      result[row['support_service_id']] += ([row['part']] - result[row['support_service_id']])
    end
    result
  end
  
  #TarifClass.update_service_parts([9335]) 
  def self.update_service_parts(service_ids = [])
    base_where_hash = service_ids.blank? ? "true" : {:id => service_ids}
    select("tarif_classes.id, array_agg(distinct part) as parts").
    joins(service_category_groups: :service_category_tarif_classes).
    joins(", jsonb_array_elements((service_category_tarif_classes.conditions->'parts')::jsonb) as part").
    where(base_where_hash).
    group("tarif_classes.id").each do |item|
      tc = TarifClass.find(item.id)
      if !item.attributes['parts'].blank?
        tc.dependency ||= {}
        tc.parts ||= []
        tc.parts += (item.attributes['parts'] - tc.parts)
        tc.save!
      end
    end
    
  end
  
  #TarifClass.copy_payment_type_from_region_tarifs_to_new_region('moskva_i_oblast', 'sankt_peterburg_i_oblast')
  def self.copy_payment_type_from_region_tarifs_to_new_region(source_region, target_region)
    return false if source_region.blank? or target_region.blank?
    ActiveRecord::Base.transaction do

      TarifClass.where("features->>'region_txt' = '#{source_region}'").each do |origin_tarif_class|
        existing_target_tarif_class = TarifClass.where("features->>'region_txt' = '#{target_region}'").
            where(:name => origin_tarif_class.name, :operator_id => origin_tarif_class.operator_id).
            where(:privacy_id => origin_tarif_class.privacy_id, :standard_service_id => origin_tarif_class.standard_service_id).first
        
        if existing_target_tarif_class
          existing_target_tarif_class.payment_type = origin_tarif_class.payment_type 
          existing_target_tarif_class.save!
        end
      end
    end
  end
  
  def self.verify_all_services_in_tarif_description_are_integer
    find_each do |tarif_class|
      tarif_class.verify_all_services_in_tarif_description_are_integer

      tarif_class.save!
    end
  end

  def verify_all_services_in_tarif_description_are_integer
    ['incompatibility', 'other_tarif_priority', 'forbidden_tarifs'].each do |key_to_substitute|
      dependency[key_to_substitute].each do |compatibility_key, incompatible_options|
        dependency[key_to_substitute][compatibility_key] ||= []
        dependency[key_to_substitute][compatibility_key] = (incompatible_options || []).map{|incompatible_option| incompatible_option.to_i }.compact.sort
      end if dependency.try(:[], key_to_substitute)
    end
    
    dependency['prerequisites'] = (dependency.try(:[], 'prerequisites') || []).map{|prerequisite| prerequisite.to_i }.compact.sort if dependency
  end

  def self.unlimited_tarifs
    includes(service_category_groups: [price_lists: :formulas]).where(:standard_service_id => 40).
      includes(:service_category_tarif_classes).where("nullif((service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::jsonb, '[]') is null").
      where(:price_formulas => {:standard_formula_id => Price::StandardFormula::Const::MaxVolumesForFixedPriceConst}) 
  end
  
  def self.unlimited_tarif_ids
    joins(service_category_groups: [price_lists: :formulas]).where(:standard_service_id => 40).
      joins(:service_category_tarif_classes).where("nullif((service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::jsonb, '[]') is null").
      where(:price_formulas => {:standard_formula_id => Price::StandardFormula::Const::MaxVolumesForFixedPriceConst}).
      pluck("distinct tarif_classes.id") - [208] #super_mts
  end

  def self.services_by_operator(operator_ids)
    if operator_ids.blank?
      none
    else
      where(:operator_id => operator_ids)
    end
  end
  
  def self.with_not_null_dependency
    where("dependency is not null")
  end
  
  def self.allowed_tarif_option_ids_for_tarif(operator_id, tarif_id)
    return [] if !operator_id or !tarif_id
    
    tarif_option_ids = []
    special_services.services_by_operator([operator_id]).each do |row|
      dependency = row['dependency']
      next if (row['is_archived'] == true or !dependency or !dependency['forbidden_tarifs'])

      if !dependency['prerequisites'].blank? and dependency['prerequisites'].include?(tarif_id)
        tarif_option_ids << row['id']
      end
      
      if !dependency['forbidden_tarifs']['to_switch_on'].blank? and !dependency['forbidden_tarifs']['to_switch_on'].include?(tarif_id)
        tarif_option_ids << row['id']
      end
      
      if dependency['prerequisites'].blank? and dependency['forbidden_tarifs']['to_switch_on'].blank?
        tarif_option_ids << row['id']
      end

#    raise(StandardError) if row['name'] == 'Везде как дома SMART'
    end

    tarif_option_ids.compact
  end
  
  def self.all_by_operator_region_and_service_type(operator_id = nil, region_txt = nil, standard_service_id = nil)
    c = Category::Region::Const
    regions = case region_txt
    when 'moskva_i_oblast';[c::Moskva]
    when 'sankt_peterburg_i_oblast'; [c::Sankt_peterburg]
    else
      []
    end
    condition_for_region = regions_sql(regions)
    condition_for_region = "(#{condition_for_region})" + " and ((features->>'region_txt') is null or (features->>'region_txt') = '#{region_txt}')" if !region_txt.blank?
    condition_for_service_type = case 
    when standard_service_id.blank?
      "true"
    when standard_service_id.is_a?(Array)
      {:standard_service_id => standard_service_id.map(&:to_i)}
    else 
      {:standard_service_id => standard_service_id.try(:to_i)}
    end
    where(:operator_id => operator_id.try(:to_i)).where(condition_for_service_type).where(condition_for_region)
  end
  
  def self.original_tarif_class
    where("(tarif_classes.features->>'secondary_tarif_class')::text is null")
  end

  def self.secondary_tarif_class
    where("tarif_classes.features->>'secondary_tarif_class' = 'true'")
  end

  def self.original_tarif_class_from_secondary(secondary_tarif_class)
    where(
      :name => secondary_tarif_class.name, :operator_id => secondary_tarif_class.operator_id, 
      :standard_service_id => secondary_tarif_class.standard_service_id, :privacy_id => secondary_tarif_class.privacy_id
    ).original_tarif_class
  end

  def original_tarif_class_from_secondary
    TarifClass.original_tarif_class_from_secondary(self).first
  end
  
  def self.test_if_original_exists_for_all_secondary
    result = []
    make_secondary_as_original = false
    secondary_tarif_class.each do |sec_tc|
      original = sec_tc.original_tarif_class_from_secondary
      if !original
        result << sec_tc.attributes
        if make_secondary_as_original
          sec_tc.features ||= {}
          sec_tc.features['secondary_tarif_class'] = nil
          sec_tc.save!
        end
      end       
    end
    result
  end

end

