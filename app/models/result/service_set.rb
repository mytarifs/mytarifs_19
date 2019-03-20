# == Schema Information
#
# Table name: result_service_sets
#
#  id                  :integer          not null, primary key
#  run_id              :integer
#  service_set_id      :string
#  tarif_id            :integer
#  operator_id         :integer
#  common_services     :integer          is an Array
#  tarif_options       :integer          is an Array
#  service_ids         :integer          is an Array
#  price               :float
#  call_id_count       :integer
#  sum_duration_minute :float
#  sum_volume          :float
#  count_volume        :integer
#  categ_ids           :jsonb
#  identical_services  :jsonb
#

class Result::ServiceSet < ActiveRecord::Base
  extend BatchInsert
  belongs_to :run, :class_name =>'Result::Run', :foreign_key => :run_id

  belongs_to :tarif, :class_name =>'TarifClass', :foreign_key => :tarif_id
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id

  def full_name
    "#{operator.name} #{tarif.name}"
  end

  def full_name_with_region
    region_name = tarif.region_txt ? Category::MobileRegions[tarif.region_txt]['name'] : "Без региона"
    "#{operator.name} #{tarif.name}, #{region_name}"
  end

  def self.best_service_set(result_run_id, m_privacy = nil, m_region = nil)
    tarif_ids_to_limit_result = TarifClass.privacy_and_region_where_with_default(m_privacy, m_region).pluck(:id)
    best_service_sets(result_run_id, 1, tarif_ids_to_limit_result).first
  end
  
  def self.best_service_sets_by_tarif(result_run_id, tarif_id, result_number = 1)
     where(:run_id => result_run_id, :tarif_id => tarif_id).order("price").limit(result_number)
  end
  
  def self.best_service_sets(result_run_id, result_number = 1, tarif_ids_to_limit_result = [])    
    if tarif_ids_to_limit_result.blank?
      where(:run_id => result_run_id).order("price").limit(result_number)
    else
      where(:run_id => result_run_id, :tarif_id => tarif_ids_to_limit_result).order("price").limit(result_number)
    end    
  end
  
end

