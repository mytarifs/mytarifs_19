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

class Customer::Info::ServiceChoices < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 8)
  end
  
  def self.info(user_id)
    where(:user_id => user_id).first_or_create(:info => default_values).info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first_or_create.update_columns(:info => values)
  end
  
  def self.services_from_session_to_optimization_format(services_chosen, privacy_id = 2, region_txt = 'moskva_i_oblast')
    result = {:operators => [], :tarifs => {}, :tarif_options => {}, :common_services => {}, }
    
     {'tel' => 1023, 'bln' => 1025, 'mgf' => 1028, 'mts' => 1030}.each do |operator_name, operator_id|
       result[:operators] << operator_id if !services_chosen['tarifs'][operator_name].blank? 
       result[:tarifs][operator_id] = (services_chosen['tarifs'][operator_name] || []).map(&:to_i)
       result[:tarif_options][operator_id] = (services_chosen['tarif_options'][operator_name] || []).map(&:to_i)
       result[:common_services][operator_id] = (services_chosen['common_services'][operator_name] || []).map(&:to_i)
     end
    result 
  end

  def self.validate_tarifs(to_validate, privacy_id = 2, region_txt = 'moskva_i_oblast') 
    validated_result = {'tarifs' => {}, 'tarif_options' => {}, 'common_services' => {}}
    tarif_results = tarifs(privacy_id, region_txt)
    common_services_results = common_services(privacy_id, region_txt)
    tarif_options_results = tarif_options(privacy_id, region_txt)
    
    operator = 1023
    validated_result['tarifs']['tel'] = to_validate['tarifs']['tel'].to_s.scan(/\d+/).map(&:to_i) & tarif_results[operator] 
    validated_result['tarif_options']['tel'] = to_validate['tarif_options']['tel'].to_s.scan(/\d+/).map(&:to_i) & tarif_options_results[operator] 
    validated_result['common_services']['tel'] = to_validate['common_services']['tel'].to_s.scan(/\d+/).map(&:to_i) & common_services_results[operator] 

    operator = 1025
    validated_result['tarifs']['bln'] = to_validate['tarifs']['bln'].to_s.scan(/\d+/).map(&:to_i) & tarif_results[operator] 
    validated_result['tarif_options']['bln'] = to_validate['tarif_options']['bln'].to_s.scan(/\d+/).map(&:to_i) & tarif_options_results[operator] 
    validated_result['common_services']['bln'] = to_validate['common_services']['bln'].to_s.scan(/\d+/).map(&:to_i) & common_services_results[operator] 

    operator = 1028
    validated_result['tarifs']['mgf'] = to_validate['tarifs']['mgf'].to_s.scan(/\d+/).map(&:to_i) & tarif_results[operator] 
    validated_result['tarif_options']['mgf'] = to_validate['tarif_options']['mgf'].to_s.scan(/\d+/).map(&:to_i) & tarif_options_results[operator] 
    validated_result['common_services']['mgf'] = to_validate['common_services']['mgf'].to_s.scan(/\d+/).map(&:to_i) & common_services_results[operator] 

    operator = 1030
    validated_result['tarifs']['mts'] = to_validate['tarifs']['mts'].to_s.scan(/\d+/).map(&:to_i) & tarif_results[operator] 
    validated_result['tarif_options']['mts'] = to_validate['tarif_options']['mts'].to_s.scan(/\d+/).map(&:to_i) & tarif_options_results[operator] 
    validated_result['common_services']['mts'] = to_validate['common_services']['mts'].to_s.scan(/\d+/).map(&:to_i) & common_services_results[operator]
    validated_result 
  end
  
  def self.simple_validate_tarifs(to_validate, privacy_id = 2, region_txt = 'moskva_i_oblast')
    result = {}
    tarif_results = tarifs(privacy_id, region_txt)
    
    operators.each do |operator|
      result[operator] = to_validate.to_s.scan(/\d+/).map(&:to_i) & tarif_results[operator]
    end
    result
  end
  
  def self.default_values(user_type = :guest, privacy_id = 2, region_txt = 'moskva_i_oblast')
    tarif_results = tarifs(privacy_id, region_txt)
    common_services_results = common_services(privacy_id, region_txt)
    tarif_options_for_demo_results = tarif_options_for_demo(user_type, privacy_id, region_txt)
    
    {
      'tarifs' => {'tel' => tarif_results[1023], 'bln' => tarif_results[1025], 'mgf' => tarif_results[1028], 'mts' => tarif_results[1030]},
      'common_services' => {'tel' => common_services_results[1023], 'bln' => common_services_results[1025], 'mgf' => common_services_results[1028], 'mts' => common_services_results[1030]}, 
      'tarif_options' => {'tel' => tarif_options_for_demo_results[1023], 'bln' => tarif_options_for_demo_results[1025], 
                          'mgf' => tarif_options_for_demo_results[1028], 'mts' => tarif_options_for_demo_results[1030]}, 
    }
  end
  
  def self.default_values_for_paid
    tarif_results = tarifs(privacy_id, region_txt)
    common_services_results = common_services(privacy_id, region_txt)
    tarif_options_results = tarif_options(privacy_id, region_txt)
    
    {
      'tarifs' => {'tel' => tarif_results[1023], 'bln' => tarif_results[1025], 'mgf' => tarif_results[1028], 'mts' => tarif_results[1030]},
      'common_services' => {'tel' => common_services_results[1023], 'bln' => common_services_results[1025], 'mgf' => common_services_results[1028], 'mts' => common_services_results[1030]}, 
      'tarif_options' => {'tel' => tarif_options_results[1023], 'bln' => tarif_options_results[1025], 'mgf' => tarif_options_results[1028], 'mts' => tarif_options_results[1030]}, 
    }
  end
  
  def self.operators
    [1023, 1025, 1028, 1030]
  end
  
  def self.all_services_by_operator(privacy_id = 2, region_txt = 'moskva_i_oblast')
    result = {}
    tarif_results = tarifs(privacy_id, region_txt)
    common_services_results = common_services(privacy_id, region_txt)
    tarif_options_results = tarif_options(privacy_id, region_txt)
    
    operators.each do |operator|
      result[operator] = tarif_results[operator] + common_services_results[operator] + tarif_options_results[operator]
    end
    result
  end

  def self.tarifs(privacy_id = 2, region_txt = 'moskva_i_oblast')    
    TarifClass.servce_ids_for_calculations(TarifClass::ServiceType[:tarif], privacy_id, region_txt)
  end  

  def self.common_services(privacy_id = 2, region_txt = 'moskva_i_oblast')    
    TarifClass.servce_ids_for_calculations(TarifClass::ServiceType[:common_service], privacy_id, region_txt)
  end  

  def self.tarif_options(privacy_id = 2, region_txt = 'moskva_i_oblast')    
    TarifClass.servce_ids_for_calculations(TarifClass::ServiceType[:special_service], privacy_id, region_txt)
  end  

  def self.tarif_options_for_demo(user_type = :guest, privacy_id = 2, region_txt = 'moskva_i_oblast')
    demo_option_types = {
      :guest => [:country_rouming, :calls, :sms, :internet], 
      :trial => [:country_rouming, :calls, :sms, :internet], 
      :user => [:international_rouming, :country_rouming, :mms, :calls, :sms, :internet],
      :admin => [:international_rouming, :country_rouming, :mms, :calls, :sms, :internet]}[user_type]
#    demo_option_types = [:international_rouming, :country_rouming, :calls, :sms, :internet]
    tarif_options_by_type_result = tarif_options_by_type(privacy_id, region_txt)
    
    {
      1023 => tarif_options_by_type_result[1023].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
      1025 => tarif_options_by_type_result[1025].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
      1028 => tarif_options_by_type_result[1028].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
      1030 => tarif_options_by_type_result[1030].map{|t| t[1] if demo_option_types.include?(t[0])}.flatten.compact,
    }
  end  

  def self.services_for_comparison(operators = [], options_for_comparison = [], privacy_id = 2, region_txt = 'moskva_i_oblast')
    result = {:operators => [], :tarifs => {}, :tarif_options => {}, :common_services => {}, }
    tarif_results = tarifs(privacy_id, region_txt)
    common_services_results = common_services(privacy_id, region_txt)
    tarif_options_for_comparison_results = tarif_options_for_comparison(options_for_comparison, privacy_id, region_txt)
    
    operators.each do |operator_id|
       result[:operators] << operator_id  
       result[:tarifs][operator_id] = tarif_results[operator_id]
       result[:tarif_options][operator_id] = tarif_options_for_comparison_results[operator_id]
       result[:common_services][operator_id] = common_services_results[operator_id]
    end
    result
  end
  
  def self.tarif_options_for_comparison(options_for_comparison_1 = [], privacy_id = 2, region_txt = 'moskva_i_oblast')
#    options_for_comparison = [:international_rouming, :country_rouming, :mms, :sms, :calls, :internet]
    options_for_comparison = options_for_comparison_1.map(&:to_sym)
    tarif_options_by_type_result = tarif_options_by_type(privacy_id, region_txt)

    result = {
      1023 => tarif_options_by_type_result[1023].map{|t| t[1] if options_for_comparison.include?(t[0])}.flatten.compact,
      1025 => tarif_options_by_type_result[1025].map{|t| t[1] if options_for_comparison.include?(t[0])}.flatten.compact,
      1028 => tarif_options_by_type_result[1028].map{|t| t[1] if options_for_comparison.include?(t[0])}.flatten.compact,
      1030 => tarif_options_by_type_result[1030].map{|t| t[1] if options_for_comparison.include?(t[0])}.flatten.compact,
    }
    result
  end  

  def self.tarif_options_by_type(privacy_id = 2, region_txt = 'moskva_i_oblast')
    TarifClass.tarif_option_ids_for_calculations_by_type(privacy_id, region_txt)
  end
  
end
