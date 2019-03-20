# == Schema Information
#
# Table name: result_tarif_results
#
#  id                  :integer          not null, primary key
#  run_id              :integer
#  tarif_id            :integer
#  part                :string
#  result              :jsonb
#

class Result::TarifResult < ActiveRecord::Base
  extend BatchInsert
  
  belongs_to :run, :class_name =>'Result::Run', :foreign_key => :run_id
  belongs_to :tarif, :class_name =>'TarifClass', :foreign_key => :tarif_id
  belongs_to :operator, :class_name =>'Category', :foreign_key => :operator_id

end

