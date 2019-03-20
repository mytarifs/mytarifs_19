# == Schema Information
#
# Table name: result_services
#
#  id                  :integer          not null, primary key
#  run_id              :integer
#  tarif_id            :integer
#  service_set_id      :string
#  service_id          :integer
#  price               :float
#  call_id_count       :integer
#  sum_duration_minute :float
#  sum_volume          :float
#  count_volume        :integer
#  categ_ids           :jsonb
#

class Result::Service < ActiveRecord::Base
  extend BatchInsert
  belongs_to :run, :class_name =>'Result::Run', :foreign_key => :run_id

  belongs_to :tarif, :class_name =>'TarifClass', :foreign_key => :tarif_id
  belongs_to :service, :class_name =>'TarifClass', :foreign_key => :service_id

end

