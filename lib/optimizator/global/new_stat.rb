module Optimizator::Global
  class NewStat < Optimization::Global::Base
    def initialize(options = {})
      super
    end
    
    def category_ids_for_global_category_stat(service_categories_by_global_category, global_category_filtr = nil, row = nil)
      result = {true => [], false => []}
      service_categories_by_global_category.each do |sc|
        raise(StandardError, [sc.attributes, "#########", 
          global_category_filtr, "########", sc.filtr]) if false and sc['name'] == '_sctcg_mts_sic_135_to_other_countries_calls_to_not_rouming_not_russia_not_sic'
        if global_category_filtr and sc['filtr']
          if Optimization::Global::Base::CategoryFiltr.new.filtr_for_stat(global_category_filtr, sc['filtr'])
            result[true] << sc['id'] 
          else
            result[false] << sc['id']
          end
        end
      end          
      result
    end
    
    def calls_by_category_groups(calls, service_ids = [])  
      global_names = service_categories_by_global_category(service_ids).keys        
      sql = calls_by_category_groups_sql(global_names)      
      rows = calls.find_by_sql("with base_calls as (#{calls.to_sql}) #{sql}")
      raise(StandardError,[
        rows[0]
      ]) 
    end
    
    def calls_by_category_groups_sql(global_names = [])
      global_names.map do |global_name|        
        part = Optimization::Global::Base::StructureByPartsHelper.part_from_uniq_service_category(global_name)
        params = params_from_global_name(global_name)
        
        fields = ["'#{global_name}' as global_name", "'#{part}' as part"] + 
          f.all_fields.map{|field| "#{field} as #{f.name_by_field(field)}"} + 
          {
            :duration => "((description->>'duration')::float)/60.0".freeze,
            :duration_sec => "(description->>'duration')::float".freeze,
            :count_volume => "case when (description->>'volume')::text is null then null else 1 end".freeze,
            :sum_volume => "(description->>'volume')::float".freeze,
          }.map{|field_name, definition| "#{definition} as #{field_name}"} 
          
        "select #{fields.join(', ')} from base_calls where #{call_filtr.filtr(params)}"
      end.join(" union all ")
    end    

    def service_categories_by_global_category(service_ids = [])
      return @service_categories_by_global_category if @service_categories_by_global_category
      result = {}
      base_service_category = Service::CategoryTarifClass.where.not(:uniq_service_category => [nil, ''])
      base_service_category = base_service_category.includes(:as_standard_category_group).
        joins(:as_standard_category_group).where(:service_category_groups => {:tarif_class_id => service_ids}) if !service_ids.blank?
      base_service_category.find_each do |sc|
        next if sc.uniq_service_category.blank?
        result[sc.uniq_service_category] ||= {}
        result[sc.uniq_service_category][sc.id] = sc.attributes 
      end
      result
    end
    
  end      
end
