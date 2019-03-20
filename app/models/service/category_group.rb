# == Schema Information
#
# Table name: service_category_groups
#
#  id             :integer          not null, primary key
#  name           :string
#  operator_id    :integer
#  tarif_class_id :integer
#  criteria       :json
#  created_at     :datetime
#  updated_at     :datetime
#  conditions     :json
#

class Service::CategoryGroup < ActiveRecord::Base
  include WhereHelper, PgJsonHelper
  
  store_accessor :criteria, :params_to_auto_update_formula_params, :status_of_auto_update
  
  belongs_to :operator, :class_name =>'::Category', :foreign_key => :operator_id
  belongs_to :tarif_class, :class_name =>'::TarifClass', :foreign_key => :tarif_class_id
  has_many :service_category_tarif_classes, :class_name =>'Service::CategoryTarifClass', :foreign_key => :as_standard_category_group_id, :dependent => :destroy
  has_many :price_lists, :class_name => '::PriceList', :foreign_key => :service_category_group_id, :dependent => :destroy
  
  def copy_full_category_definition(service_id_to_copy_to = nil)
    new_service_category_group = Service::CategoryGroup.new(attributes.symbolize_keys.except(:id, :created_at, :updated_at)) do |tc|
      tc.tarif_class_id = service_id_to_copy_to if service_id_to_copy_to
      if !tc.params_to_auto_update_formula_params.blank?
        tc.status_of_auto_update = {}
        tc.status_of_auto_update['formula_params'] = {'modified' => 'true', 'syncronised' => 'false', 'updated' => Time.now}
        if !tc.params_to_auto_update_formula_params['regions_for_sctc'].blank?
          tc.status_of_auto_update['sctc_params'] = {'modified' => 'true', 'syncronised' => 'false', 'updated' => Time.now}
        end
      end
    end
    ActiveRecord::Base.transaction do
      new_service_category_group.save!
      
      new_service_category_tarif_class_ids = {}
      service_category_tarif_classes.each do |service_category_tarif_class|
        
        new_service_category_tarif_class = Service::CategoryTarifClass.
          create!(service_category_tarif_class.attributes.symbolize_keys.except(:id, :as_standard_category_group_id, :created_at, :updated_at)) do |sctc|
          
          sctc.as_standard_category_group_id = new_service_category_group.id
          sctc.tarif_class_id = service_id_to_copy_to if service_id_to_copy_to                    
        end
        
        new_service_category_tarif_class_ids[service_category_tarif_class.id] = new_service_category_tarif_class.id
      end
      
      possible_sctc_ids = new_service_category_group.service_category_tarif_classes.pluck(:id)
      (self.params_to_auto_update_formula_params.try(:[], 'regions_for_sctc') || {}).each do |original_sctc_key, value|
        sctc_key = ((original_sctc_key.split(/[^[[:word:]]]+/) || []) - ['']).map(&:to_i)
        new_sctc_key = sctc_key.map{|sctc_id| new_service_category_tarif_class_ids[sctc_id]}.to_s
        new_service_category_group.params_to_auto_update_formula_params['regions_for_sctc'].extract!(original_sctc_key)
        new_service_category_group.params_to_auto_update_formula_params['regions_for_sctc'][new_sctc_key] = value
      end
      
      new_service_category_group.save!

      price_lists.each do |price_list|
        
        new_price_list = PriceList.create!(price_list.attributes.symbolize_keys.except(:id, :service_category_group_id, :created_at, :updated_at)) do |pl|              
          pl.service_category_group_id = new_service_category_group.id
        end
        
        price_list.formulas.each do |formula|
          Price::Formula.create!(formula.attributes.symbolize_keys.except(:id, :price_list_id, :created_at, :updated_at)) do |f|
            f.price_list_id = new_price_list.id
          end
        end
      end

    end
    new_service_category_group
  end

  def self.add_full_category_definition(tarif_class_id)
    return false if tarif_class_id.blank?

    ActiveRecord::Base.transaction do
      new_service_category_group = Service::CategoryGroup.create!({:tarif_class_id => tarif_class_id})

      Service::CategoryTarifClass.create!({
          :as_standard_category_group_id => new_service_category_group.id,
          :tarif_class_id => tarif_class_id
        })

      new_price_list = PriceList.create!({:tarif_class_id => tarif_class_id, :service_category_group_id => new_service_category_group.id})

      Price::Formula.create!({:price_list_id => new_price_list.id, :calculation_order => 0, :standard_formula_id => 0})

    end
  end
  
  #Service::CategoryGroup.check_formulas_has_all_regions
  def self.check_formulas_has_all_regions
    regions_from_tarif = {}; regions_from_formulas = {}; 
    checked_scgs = [247636, 247749, 247750, 247780, 263044, 263045, 263046, 263047, 245080, 245081, 263093, 263098, 245709, 263099, 263100, 263101, 247942, 247951, 263132,
      258904, 258915, 263104, 263105, 263106, 263107, 263108, 263109, 263110, 259200, 263037, 263038, 263039, 263040, 263043, 261491, 261494, 261623, 261629, 261633, 263118, 263119, 263120,
      263124, 263126, 263129, 263130, 263131, 246009, 264045, 264046, 246075, 264066, 246114, 264064, 264067, 246142, 264065, 264068, 246216, 246219, 263789,
      246334, 264035, 264037, 264039, 
      246518, 246520, 259051, 259054, 259057, 259060, 263810, 263812, 263814, 263816, 263818, 263820, 263822, 263832, 263834, 263837, 263842, 263843,
      264069, 264070,
      246939, 246940, 246946, 246947, 246948, 262776, 262777,
      246972, 246980, 246981, 246982, 262865,
      247037, 262717, 262753,
      247090, 247106,
      247121, 247131, 262757, 262762,
      247178, 262754,
      247205, 247220, 262768, 262770,
      247281, 247291, 262845,
      247339, 247340, 262771, 262772,
      260955, 260960, 260961, 260970, 260971, 262851, 262862, 262863, 262864,
      259922, 262550,
      259957, 262558,
      259968,
      ]
    TarifClass.
      select("id, 11 as regions_number" ).
      original_tarif_class.where("nullif(tarif_classes.features#>>'{regions}', '[]') is null").
      map{|item| regions_from_tarif[item.id] = item.regions_number}

    TarifClass.
#      select("id, (json_array_length(tarif_classes.features#>'{regions}')) as regions_number" ).
      select("id, (json_array_length(tarif_classes.features#>'{regions}') - json_array_length(tarif_classes.features#>'{archived_regions}')) as regions_number" ).
      original_tarif_class.where("nullif(tarif_classes.features#>>'{regions}', '[]') is not null").
      map{|item| regions_from_tarif[item.id] = item.regions_number}
    
    select("count(distinct service_category_tarif_classes.id) as divider, service_category_groups.id, service_category_groups.tarif_class_id, tarif_classes.name, tarif_classes.operator_id, 
      sum(json_array_length(price_formulas.formula->'regions')) as regions_number" ).
    joins(:tarif_class, :service_category_tarif_classes, :price_lists => :formulas).
    where(:tarif_classes => {:standard_service_id => 40}).
    where("nullif(service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options', '[]') is null").
    order("tarif_classes.privacy_id desc, tarif_classes.operator_id").
    group("service_category_groups.id, service_category_groups.tarif_class_id, tarif_classes.name, tarif_classes.operator_id, tarif_classes.privacy_id").each do |item|
      next if item.regions_number.nil? or (item.regions_number / item.divider) >= regions_from_tarif[item.tarif_class_id]
      next if checked_scgs.include?(item.id)
      
      raise(StandardError, [
        item.divider,
        item.regions_number,
      ]) if false
      regions_from_formulas[item.tarif_class_id] ||= {:desc => [item.operator_id, item.name, regions_from_tarif[item.tarif_class_id]], :cgs => {}}
      regions_from_formulas[item.tarif_class_id][:cgs][item.id] = (item.regions_number / item.divider)
    end
    
    
    
    regions_from_formulas
  end

end

