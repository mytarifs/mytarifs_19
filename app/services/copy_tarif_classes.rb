class CopyTarifClasses
  
  attr_reader :source_region_txt, :target_region_txt, :source_privacy_id, :target_privacy_id
  
  def initialize(source_region_txt, target_region_txt, source_privacy_id, target_privacy_id)
    @source_region_txt = source_region_txt
    @target_region_txt = target_region_txt
    @source_privacy_id = source_privacy_id.try(:to_i)
    @target_privacy_id = target_privacy_id.try(:to_i)
  end

  #
  def copy_all_services_from_one_region_and_privacy_to_other_region_and_privacy
    return false if is_target_region_and_privacy_equal_to_source? or target_region_txt.blank? or target_privacy_id.blank?
    ActiveRecord::Base.transaction do
      TarifClass.where("features->>'region_txt' = '#{source_region_txt}'").where(:privacy_id => source_privacy_id).each do |origin_tarif_class|

        existing_target_tarif_class = TarifClass.
          where("features->>'region_txt' = '#{target_region_txt}'").
          where(:name => origin_tarif_class.name, :operator_id => origin_tarif_class.operator_id).
          where(:privacy_id => target_privacy_id, :standard_service_id => origin_tarif_class.standard_service_id).first
        
        copy_full_tarif_definition(origin_tarif_class) if !existing_target_tarif_class
      end      
      
      TarifClass.where("features->>'region_txt' = '#{target_region_txt}'").where(:privacy_id => target_privacy_id).each do |target_service|
        update_full_tarif_definition_with_new_region_privacy_and_service_info(target_service)
      end      
    end
  end
  
  def update_full_tarif_definition_with_new_region_privacy_and_service_info(target_service)
    ['incompatibility', 'other_tarif_priority', 'forbidden_tarifs'].each do |key_to_substitute|
      target_service.dependency[key_to_substitute].each do |compatibility_key, incompatible_options|
        target_service.dependency[key_to_substitute][compatibility_key] ||= []
        target_service.dependency[key_to_substitute][compatibility_key] = (incompatible_options || []).
          map{|incompatible_option| service_pairs[incompatible_option] || incompatible_option}.compact
      end if target_service.dependency[key_to_substitute]
    end
    
    target_service.dependency['prerequisites'] = (target_service.dependency['prerequisites'] || []).
      map{|prerequisite| service_pairs[prerequisite] || prerequisite}.compact
    
    target_service.save!
    
    target_service.service_category_groups.each do |service_category_group|
      service_category_group.service_category_tarif_classes.each do |sctc|
        sctc.conditions['tarif_set_must_include_tarif_options'] = sctc.conditions['tarif_set_must_include_tarif_options'].
          map{|service| service_pairs[service] || service}.compact if sctc.conditions['tarif_set_must_include_tarif_options']
        
        ['own_country_regions', 'to_own_and_home_regions', 'own_and_home_regions'].each do |key_to_substitute|
          ['in', 'not_in'].each do |logic_key|
            sctc.filtr[key_to_substitute][logic_key] = sctc.filtr[key_to_substitute][logic_key].map do |region| 
              region_pairs[region] ? region_pairs[region] : region
            end.compact if sctc.filtr.try(:[], key_to_substitute).try(:[], logic_key)
          end 
        end 
        
        sctc.save!
      end
    end
  end
  
  def copy_full_tarif_definition(existing_tarif_class)
    new_tarif_class = TarifClass.new(new_tarif_class_attributes_from_existing_tarif_class(existing_tarif_class) )

    ActiveRecord::Base.transaction do
      new_tarif_class.save!
      copy_additional_tarif_definition_tables(existing_tarif_class, new_tarif_class)
    end
    new_tarif_class
  end
  
  def new_tarif_class_attributes_from_existing_tarif_class(existing_tarif_class)
    new_tarif_class_attributes = existing_tarif_class.attributes.symbolize_keys.except(:id, :slug, :created_at, :updated_at).merge({
      :publication_status => Content::Article::PublishStatus[:draft],
    })
    
    if is_target_region_and_privacy_equal_to_source?
      new_tarif_class_attributes[:name] = "copy of #{existing_tarif_class.name}"
    else
      if source_region_txt != target_region_txt
        new_tarif_class_attributes[:region_txt] = target_region_txt
        new_tarif_class_attributes.merge!(new_tarif_class_https(existing_tarif_class))
      end

      new_tarif_class_attributes[:privacy_id] = target_privacy_id if source_privacy_id != target_privacy_id
    end
    new_tarif_class_attributes
  end
  
  def new_tarif_class_https(existing_tarif_class)
    result = {}
    if [source_region_txt, target_region_txt].all?{|region_txt| Category::MobileRegions.try(:[], region_txt).try(:[], 'domain').try(:[], existing_tarif_class.operator_id) }
      source_doman_names = Category::MobileRegions[source_region_txt]['domain'][existing_tarif_class.operator_id]
      target_doman_name = Category::MobileRegions[target_region_txt]['domain'][existing_tarif_class.operator_id][0]

      result[:http] = existing_tarif_class.http.gsub(/#{source_doman_names.join('|')}/, target_doman_name) if !existing_tarif_class.http.blank?
      result[:buy_http] = existing_tarif_class.buy_http.gsub(/#{source_doman_names.join('|')}/, target_doman_name) if !existing_tarif_class.buy_http.blank?
    end
    result
  end
  
  def copy_additional_tarif_definition_tables(existing_tarif_class, new_tarif_class)
    existing_tarif_class.service_category_groups.each do |service_category_group|        
      new_service_category_group = Service::CategoryGroup.
        create!(service_category_group.attributes.symbolize_keys.except(:id, :tarif_class_id, :created_at, :updated_at)) do |scg|            
        scg.tarif_class_id = new_tarif_class.id
      end
      
      service_category_group.service_category_tarif_classes.each do |service_category_tarif_class|          
        Service::CategoryTarifClass.
          create!(service_category_tarif_class.attributes.symbolize_keys.except(:id, :tarif_class_id, :as_standard_category_group_id, :created_at, :updated_at)) do |sctc|            
          sctc.tarif_class_id = new_tarif_class.id
          sctc.as_standard_category_group_id = new_service_category_group.id
        end
      end
      
      service_category_group.price_lists.each do |price_list|          
        new_price_list = PriceList.create!(price_list.attributes.symbolize_keys.except(:id, :tarif_class_id, :service_category_group_id, :created_at, :updated_at)) do |pl|              
          pl.tarif_class_id = new_tarif_class.id
          pl.service_category_group_id = new_service_category_group.id
        end
        
        price_list.formulas.each do |formula|
          Price::Formula.create!(formula.attributes.symbolize_keys.except(:id, :price_list_id, :created_at, :updated_at)) do |f|
            f.price_list_id = new_price_list.id
          end
        end
      end
    end
  end
  
  def is_target_region_and_privacy_equal_to_source?
    (source_region_txt == target_region_txt and source_privacy_id == target_privacy_id)
  end
  
  def region_pairs
    return @region_pairs if @region_pairs
    @region_pairs = {}
    Category::MobileRegions[source_region_txt]['region_ids'].each_with_index{|region_id, index| @region_pairs[region_id] = Category::MobileRegionsons[target_region_txt]['region_ids'][index]}
    Category::MobileRegions[target_region_txt]['region_ids'].each_with_index{|region_id, index| @region_pairs[region_id] = Category::MobileRegions[source_region_txt]['region_ids'][index]}
    @region_pairs
  end
  
  def service_pairs(source_service_ids = [])
    return @service_pairs if @service_pairs and source_service_ids.blank?
    @service_pairs = {}
    
    source_tarif_class_sql = TarifClass.where("features->>'region_txt' = '#{source_region_txt}'").where(:privacy_id => source_privacy_id)
    source_tarif_class_sql = source_tarif_class_sql.where(:id => source_service_ids) if !source_service_ids.blank?
    source_tarif_class_sql = source_tarif_class_sql.to_sql

    target_tarif_class_sql = TarifClass.where("features->>'region_txt' = '#{target_region_txt}'").where(:privacy_id => target_privacy_id).to_sql
    sql = "with source_tarif_class as ( #{source_tarif_class_sql} ), target_tarif_class as ( #{target_tarif_class_sql} ) " +
          "select source_tarif_class.id as source_tarif_class_id, target_tarif_class.id as target_tarif_class_id from source_tarif_class, target_tarif_class " +
          "where source_tarif_class.standard_service_id = target_tarif_class.standard_service_id " +
          " and source_tarif_class.name = target_tarif_class.name"
    TarifClass.find_by_sql(sql).each do |row|
      @service_pairs[row.source_tarif_class_id] = row.target_tarif_class_id
    end
    @service_pairs
  end
  
end

