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

class Customer::Info::ServicesSelect < ActiveType::Record[Customer::Info]
  def self.default_scope
    where(:info_type_id => 9)
  end

  def self.info(user_id)
    where(:user_id => user_id).first_or_create(:info => default_values(:guest)).info
  end
  
  def self.update_info(user_id, values)
    where(:user_id => user_id).first_or_create.update_columns(:info => values)
  end
  
  def self.default_values(user_type)
    {
     :guest => {
         'operator_tel' => 'true','operator_bln' => 'true', 'operator_mgf' => 'true', 'operator_mts' => 'true',
        'tarifs' => 'true', 'common_services' => 'true', 'all_tarif_options' => 'false'
      },
     :trial => {
         'operator_tel' => 'true','operator_bln' => 'true', 'operator_mgf' => 'true', 'operator_mts' => 'true',
        'tarifs' => 'true', 'common_services' => 'true', 'all_tarif_options' => 'false', 'calls' => 'true', 'sms' => 'true', 'internet' => 'true'
      },
     :user => {
         'operator_tel' => 'true','operator_bln' => 'true', 'operator_mgf' => 'true', 'operator_mts' => 'true',
        'tarifs' => 'true', 'common_services' => 'true', 'all_tarif_options' => 'true'
      },
     :admin => {
         'operator_tel' => 'true','operator_bln' => 'true', 'operator_mgf' => 'true', 'operator_mts' => 'true',
        'tarifs' => 'true', 'common_services' => 'true', 'all_tarif_options' => 'true'
      },
    }[user_type]
  end

  def self.process_selecting_services(params, privacy_id, region_txt)
    service_choices_filtr ||= {}
    service_choices_filtr['tarifs'] ||= {}
    service_choices_filtr['common_services'] ||= {}
    service_choices_filtr['tarif_options'] ||= {}
    if params
      if params['operator_tel'] == 'true'
        input = selected_services(1023, params, privacy_id, region_txt)
        service_choices_filtr['tarifs']['tel'] = input['tarifs']
    raise(StandardError, [
      params,
      input,
      
#      selected_services(operator, params),
      ]) if false
        service_choices_filtr['common_services']['tel'] = input['common_services']
        service_choices_filtr['tarif_options']['tel'] = input['tarif_options']
      end
      if params['operator_bln'] == 'true'
        input = selected_services(1025, params, privacy_id, region_txt)
        service_choices_filtr['tarifs']['bln'] = input['tarifs']
        service_choices_filtr['common_services']['bln'] = input['common_services']
        service_choices_filtr['tarif_options']['bln'] = input['tarif_options']
      end
      if params['operator_mgf'] == 'true'
        input = selected_services(1028, params, privacy_id, region_txt)
        service_choices_filtr['tarifs']['mgf'] = input['tarifs']
        service_choices_filtr['common_services']['mgf'] = input['common_services']
        service_choices_filtr['tarif_options']['mgf'] = input['tarif_options']
      end
      if params['operator_mts'] == 'true'
        input = selected_services(1030, params, privacy_id, region_txt)
        service_choices_filtr['tarifs']['mts'] = input['tarifs']
        service_choices_filtr['common_services']['mts'] = input['common_services']
        service_choices_filtr['tarif_options']['mts'] = input['tarif_options']
      end
    end
    service_choices_filtr
  end
  
  def self.selected_services(operator, params, privacy_id, region_txt)
    result = {}
    result['tarifs'] = (params['tarifs'] == 'true') ? Customer::Info::ServiceChoices.tarifs(privacy_id, region_txt)[operator] : []
    result['common_services'] = (params['common_services'] == 'true') ? Customer::Info::ServiceChoices.common_services(privacy_id, region_txt)[operator] : []
    if params['all_tarif_options'] == 'true'
      result['tarif_options'] = Customer::Info::ServiceChoices.tarif_options(privacy_id, region_txt)[operator]
    else
      result['tarif_options'] = []
      existing_tarif_options = Customer::Info::ServiceChoices.tarif_options_by_type(privacy_id, region_txt)[operator]
      result['tarif_options'] += (params['international_rouming'] == 'true') ? existing_tarif_options[:international_rouming] : []
      result['tarif_options'] += (params['country_rouming'] == 'true') ? existing_tarif_options[:country_rouming] : []
      result['tarif_options'] += (params['calls'] == 'true') ? existing_tarif_options[:calls] : []
      result['tarif_options'] += (params['internet'] == 'true') ? existing_tarif_options[:internet] : []
      result['tarif_options'] += (params['sms'] == 'true') ? existing_tarif_options[:sms] : []
      result['tarif_options'] += (params['mms'] == 'true') ? existing_tarif_options[:mms] : []      
      result['tarif_options'].uniq!
    end
    result
  end
  
end
