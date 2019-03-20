# == Schema Information
#
# Table name: service_category_tarif_classes
#
#  id                                 :integer          not null, primary key
#  tarif_class_id                     :integer
#  service_category_one_time_id       :integer
#  service_category_periodic_id       :integer
#  as_standard_category_group_id      :integer
#  as_tarif_class_service_category_id :integer
#  tarif_class_service_categories     :integer          default([]), is an Array
#  standard_category_groups           :integer          default([]), is an Array
#  is_active                          :boolean
#  created_at                         :datetime
#  updated_at                         :datetime
#  name                               :text
#  conditions                         :json
#  tarif_option_id                    :integer
#  tarif_option_order                 :integer
#  uniq_service_category              :string
#

#should be deleted -  as_tarif_class_service_category_id, tarif_option_id, tarif_option_order, tarif_class_service_categories, standard_category_groups
class Service::CategoryTarifClass < ActiveRecord::Base
  include WhereHelper
  belongs_to :service_category_one_time, :class_name =>'Service::Category', :foreign_key => :service_category_one_time_id
  belongs_to :service_category_periodic, :class_name =>'Service::Category', :foreign_key => :service_category_periodic_id
  belongs_to :as_standard_category_group, :class_name =>'Service::CategoryGroup', :foreign_key => :as_standard_category_group_id
  belongs_to :tarif_class, :class_name =>'TarifClass', :foreign_key => :tarif_class_id
  has_many :price_list, :class_name => '::PriceList', :foreign_key => :service_category_tarif_class_id
  has_many :group_price_list, :class_name => '::PriceList', :foreign_key => :as_tarif_class_service_category_id
#  belongs_to :tarif_option, :class_name =>'TarifClass', :foreign_key => :tarif_option_id

  def self.active; where(:is_active => true); end
  
  def name
    raise(StandardError, self.attributes) if false
    result = []
    result << tarif_class.name if tarif_class 
    result << service_category_one_time.name if service_category_one_time 
    result << service_category_periodic.name if service_category_periodic 
    result << uniq_service_category if uniq_service_category 
    result << filtr.to_s if filtr 
    
    result.join(', ')  
  end
  
  def self.regions_sql(regions = [], filtr_type = 'all') 
    return where("true") if regions.blank?
    regions = [regions] if !regions.is_a?(Array)
    regions = regions.map(&:to_i)
    condition = filtr_type == 'all' ? '@>' : '&&'
    where_string_array = [
      "nullif((service_category_tarif_classes.conditions->'regions')::jsonb, '[]') is null",    
      "ARRAY(SELECT json_array_elements_text( service_category_tarif_classes.conditions#>'{regions}' )) #{condition} '{ #{regions.join(', ')} }'",
    ]
    where_string_array.join(' or ')      
  end

  def self.with_operator(operator_id)
    operator_id ? joins(:tarif_class).where('tarif_classes.operator_id = ?', operator_id.to_i ) : self 
  end
  
  def self.with_as_standard_category_group(group_id)
    group_id ? where("as_standard_category_group_id = ?", group_id.to_i) : self 
  end
  
  def self.find_ids_by_tarif_class_ids(tarif_class_ids)
    where(:tarif_class_id => tarif_class_ids).pluck(:id).uniq
  end

  def copy_full_category_tarif_class_definition
    Service::CategoryTarifClass.create!(attributes.symbolize_keys.except(:id, :created_at, :updated_at))
  end
  
  #Service::CategoryTarifClass.wrong_filtr_categories
  def self.wrong_filtr_categories
    where(:uniq_service_category => ["own_and_home_regions/sms_out/to_abroad", "own_country_regions/sms_out/to_abroad"]).
    where("true").
#    where(:filtr => nil).
#    where("filtr ? 'to_abroad'").
    find_each do |item|
#      item.filtr = item.filtr.except('to_abroad').merge({'to_abroad_countries' => item.filtr['to_abroad']})
      item.uniq_service_category = (item.uniq_service_category.split('/')[0..1] + ['to_abroad_countries']).join('/')
      item.save!
    end
  end
  
  #Service::CategoryTarifClass.check_and_amment_wrong_tarif_class_ids
  def self.check_and_amment_wrong_tarif_class_ids    
    includes(as_standard_category_group: :tarif_class).
      where("tarif_classes.id != service_category_tarif_classes.tarif_class_id").references(as_standard_category_group: :tarif_class).each do |service_category_tarif_class|
      service_category_tarif_class.tarif_class_id = service_category_tarif_class.as_standard_category_group.tarif_class.id
      service_category_tarif_class.save
    end
  end
  
end
