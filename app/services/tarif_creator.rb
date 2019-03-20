class TarifCreator #ServiceHelper::TarifCreator  
  attr_reader :options, :operator_id, :tarif_class_id
  attr_reader :tarif_country_id, :tarif_region_id, :tarif_home_region_ids, :tarif_own_and_home_region_ids

  def initialize(operator_id, options = {})
    @operator_id = operator_id
    @options = options
    @tarif_country_id = options[:tarif_country_id] || 1100
    @tarif_region_id = options[:tarif_region_id] || Category::Region::Const::Moskva
    @tarif_home_region_ids = options[:tarif_home_region_ids] || [1127]
    @tarif_own_and_home_region_ids = @tarif_home_region_ids + [@tarif_region_id]
  end
  
  def create_tarif_class(tarif_class_values)
    i = 0
    begin
      tarif_class = TarifClass.find_or_create_by(:name => tarif_class_values[:name], :operator_id => operator_id)
    rescue ActiveRecord::RecordNotUnique
      retry if i < 5
      i += 1 
    end    
    @tarif_class_id = tarif_class[:id]
    tarif_class = TarifClass.update(tarif_class[:id], {:operator_id => operator_id}.merge(tarif_class_values) )
  end    
  
  def add_only_service_category_tarif_class(service_category_tarif_class_field_values, condition_when_apply_sctc = {})    
    begin
      parts = classify_service_parts(service_category_tarif_class_field_values.except(:filtr))
      conditions = {:parts => parts}.merge(condition_when_apply_sctc)

      tarif_category = Service::CategoryTarifClass.create( 
        {:tarif_class_id => tarif_class_id, :is_active => true}.
          merge(service_category_tarif_class_field_values).merge(:conditions => conditions)  )
    rescue ActiveRecord::RecordNotUnique
      retry
    ensure
      tarif_category
    end        
  end
  
  def add_one_service_category_tarif_class(service_category_tarif_class_field_values, price_list_field_values, formula_field_values, condition_when_apply_sctc = {})
    begin
      service_category_group = Service::CategoryGroup.create(:tarif_class_id => tarif_class_id)
      service_category_group.update({:name => service_category_group[:id].to_s, :operator_id => operator_id} ) 
  
      price = PriceList.create({:service_category_group_id => service_category_group[:id], :is_active => true}.merge(price_list_field_values) )
  
      formulas = Price::Formula.create({:price_list_id => price[:id], :calculation_order => 0}.merge(formula_field_values) ) 
      
      tarif_category = Service::CategoryTarifClass.create( 
        {:tarif_class_id => tarif_class_id, :as_standard_category_group_id => service_category_group[:id], :is_active => true}.
          merge(service_category_tarif_class_field_values)  )

      parts = classify_service_parts(service_category_tarif_class_field_values.except(:filtr))
      conditions = {:parts => parts}.merge(condition_when_apply_sctc)

      tarif_category = Service::CategoryTarifClass.update(tarif_category[:id], {:conditions => conditions}) 
      
    rescue ActiveRecord::RecordNotUnique
      retry
    end        
    tarif_category
  end
  
  def add_grouped_service_category_tarif_class(service_category_tarif_class_field_values, standard_category_group_id, condition_when_apply_sctc = {})
      tarif_category = Service::CategoryTarifClass.create( 
        {:tarif_class_id => tarif_class_id, :as_standard_category_group_id => standard_category_group_id, :is_active => true}.
            merge(service_category_tarif_class_field_values)  )

      parts = classify_service_parts(service_category_tarif_class_field_values.except(:filtr))
      conditions = {:parts => parts}.merge(condition_when_apply_sctc)
      tarif_category = Service::CategoryTarifClass.update(tarif_category[:id], {:conditions => conditions}) 
  end
  
  def add_service_category_group(service_category_group_values, price_list_field_values, formula_field_values)
    begin
      service_category_group = Service::CategoryGroup.find_or_create_by(:name => service_category_group_values[:name], :tarif_class_id => tarif_class_id)
      service_category_group = Service::CategoryGroup.update(service_category_group[:id],
        {:id => service_category_group[:id], :operator_id => operator_id}.merge(service_category_group_values) ) 
  
      price = PriceList.find_or_create_by(:name => price_list_field_values[:name])
      PriceList.update(price[:id],
        {:service_category_group_id => service_category_group[:id], :is_active => true}.merge(price_list_field_values) )
  
      formulas = Price::Formula.find_or_create_by(:name => "formula for #{service_category_group[:name]} order #{( formula_field_values[:calculation_order] || 0 )}")
      Price::Formula.update(formulas[:id],
        {:price_list_id => price[:id], :calculation_order => 0}.merge(formula_field_values) ) 
    rescue ActiveRecord::RecordNotUnique
      retry
    end    
    service_category_group
  end

  def add_tarif_class_categories
    begin
      tarif_class = TarifClass.find(tarif_class_id)
    rescue ActiveRecord::RecordNotFound
      raise(ActiveRecord::RecordNotFound, [tarif_class_id, TarifClass.pluck(:id)] )
      retry
    end    

    parts = classify_service_parts(:tarif_class_id => tarif_class_id)
    dependency = tarif_class[:dependency].merge({:parts => parts} )
    TarifClass.update(tarif_class_id, {:dependency => dependency})    
  end
  
  def classify_service_parts(where_condition)
    parts = []
    service_category_tarif_classes(where_condition).each do |service_category_tarif_class|
      parts += ([part_from_service_category_tarif_class(service_category_tarif_class.attributes)] - parts)
    end
    parts
  end    

  def service_category_tarif_classes(where_condition)
    fields = [
      "uniq_service_category",
      "service_category_one_time_id",
      "service_category_periodic_id",
      ].join(', ')
    Service::CategoryTarifClass.select(fields).where(where_condition).distinct.all
  end
  
  def part_from_service_category_tarif_class(service_category_tarif_class_attributes)
    Optimization::Global::Base::StructureByPartsHelper.part_from_service_category_tarif_class(service_category_tarif_class_attributes)
  end

end
