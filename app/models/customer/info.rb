# == Schema Information
#
# Table name: customer_infos
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  info_type_id :integer
#  info         :json
#  last_update  :datetime
#

class Customer::Info < ActiveRecord::Base
#  include PgJsonHelper, WhereHelper, PgCreateHelper
  store_accessor :info, :call_run, :tasks

  belongs_to :user, :class_name =>'User', :foreign_key => :user_id
  belongs_to :info_type, :class_name =>'Customer::Category', :foreign_key => :info_type_id
  
  Customer::Info::Types = {
    :general => 1,
    :cash => 2,
    :services_used => 3,
    :calls_generation_params => 4,
    :calls_details_params => 5,
    :calls_parsing_params => 6,
    :tarif_optimization_params => 7,
    :service_choices => 8,
    :services_select => 9,
    :service_categories_select => 10,
    :calculation_choices => 11,
    :tarif_optimization_final_results => 12,
    :tarif_optimization_minor_results => 13,
    :tarif_optimization_process_status => 14,
  }

  scope :general, -> {where(:info_type_id => 1)}
  scope :cash, -> {where(:info_type_id => 2)}
  scope :services_used, -> {where(:info_type_id => 3)}
  scope :calls_generation_params, -> {where(:info_type_id => 4)}
  scope :calls_details_params, -> {where(:info_type_id => 5)}
  scope :calls_parsing_params, -> {where(:info_type_id => 6)}
  scope :tarif_optimization_params, -> {where(:info_type_id => 7)}
  scope :service_choices, -> {where(:info_type_id => 8)}
  scope :services_select, -> {where(:info_type_id => 9)}
  scope :service_categories_select, -> {where(:info_type_id => 10)}
  scope :calculation_choices, -> {where(:info_type_id => 14)}
  scope :tarif_optimization_final_results, -> {where(:info_type_id => 11)}
  scope :tarif_optimization_minor_results, -> {where(:info_type_id => 12)}
  scope :tarif_optimization_process_status, -> {where(:info_type_id => 13)}
  
#  after_save :create_customer_transaction
  
  private
  
  def create_customer_transaction
    result = Customer::Transaction.create(:user_id => self.user_id, :info_type_id => self.info_type_id, :status => {}, :description => self.info.to_json, :made_at => Time.zone.now)
  end
end