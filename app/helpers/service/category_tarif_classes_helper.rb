module Service::CategoryTarifClassesHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::SessionInitializers

  def service_category_tarif_class
    @service_category_tarif_class
  end
  
  def service_category_tarif_class_form
    create_formable(service_category_tarif_class)
  end  
  
  def check_service_category_tarif_class_params_before_update
    if params["service_category_tarif_class"]
#      params["service_category_tarif_class"]['id'] = nil if params["service_category_tarif_class"]['id'].blank? 
#      params["service_category_tarif_class"][:id] = params["service_category_tarif_class"][:id].to_i if !params["service_category_tarif_class"][:id].blank? 

      params["service_category_tarif_class"]['service_category_one_time_id'] = nil if params["service_category_tarif_class"]['service_category_one_time_id'].blank? 
      params["service_category_tarif_class"]['service_category_periodic_id'] = nil if params["service_category_tarif_class"]['service_category_periodic_id'].blank?
      
      params["service_category_tarif_class"]['uniq_service_category'] ||= {}
      params["service_category_tarif_class"]['uniq_service_category']['rouming'] = nil if params["service_category_tarif_class"]['uniq_service_category']['rouming'].blank?
      params["service_category_tarif_class"]['uniq_service_category']['service'] = nil if params["service_category_tarif_class"]['uniq_service_category']['service'].blank?
      params["service_category_tarif_class"]['uniq_service_category']['direction'] = nil if params["service_category_tarif_class"]['uniq_service_category']['direction'].blank?
      params["service_category_tarif_class"]['uniq_service_category']['partner'] = nil if params["service_category_tarif_class"]['uniq_service_category']['partner'].blank?

      params["service_category_tarif_class"]['conditions'] ||= {}
      params["service_category_tarif_class"]['conditions']['tarif_set_must_include_tarif_options'] ||= []
      params["service_category_tarif_class"]['conditions']['tarif_set_must_include_tarif_options'] -= [""]
      params["service_category_tarif_class"]['conditions']['tarif_set_must_include_tarif_options'] = params["service_category_tarif_class"]['conditions']['tarif_set_must_include_tarif_options'].map(&:to_i)
      params["service_category_tarif_class"]['conditions']['regions'] ||= []
      params["service_category_tarif_class"]['conditions']['regions'] -= [""]
      params["service_category_tarif_class"]['conditions']['regions'] = params["service_category_tarif_class"]['conditions']['regions'].map(&:to_i)


      params["service_category_tarif_class"]['filtr'] ||= {}
      params["service_category_tarif_class"]['filtr_keys'] ||= {}
      if !params["service_category_tarif_class"]['filtr']["new_filtr_key"].blank? and !params["service_category_tarif_class"]['filtr']["new_filtr_key_type"].blank?
        params["service_category_tarif_class"]['filtr'][params["service_category_tarif_class"]['filtr']["new_filtr_key"]] ||= {} 
        params["service_category_tarif_class"]['filtr'][params["service_category_tarif_class"]['filtr']["new_filtr_key"]][params["service_category_tarif_class"]['filtr']["new_filtr_key_type"]] ||= [] 
        params["service_category_tarif_class"]['filtr'].extract!("new_filtr_key", "new_filtr_key_type")
      end
      raise(StandardError, [
        params["service_category_tarif_class"]['filtr_keys'],
        params["service_category_tarif_class"]['filtr'].keys
      ]) if false

      params["service_category_tarif_class"]['filtr_keys'].each do |filtr_key, value_by_type|
        value_by_type.each do |filtr_type, value|
          next if ["name"].include?(filtr_type)
          params["service_category_tarif_class"]['filtr'].extract!(filtr_key) if value.blank?
        end
      end       
      
      params["service_category_tarif_class"]['filtr'].each do |filtr_key, filtr_by_type_value|
        next if ["new_filtr_key", "new_filtr_key_type"].include?(filtr_key)
        if params["service_category_tarif_class"]['filtr'][filtr_key].blank?
          params["service_category_tarif_class"]['filtr'][filtr_key] = nil 
        else
          params["service_category_tarif_class"]['filtr'][filtr_key].each do |filtr_type, filtr_value|
            if ["name"].include?(filtr_type)
              params["service_category_tarif_class"]['filtr'][filtr_key].extract!(filtr_type) if params["service_category_tarif_class"]['filtr'][filtr_key][filtr_type].blank?
            else
              if !params["service_category_tarif_class"]['filtr'][filtr_key].blank?
                params["service_category_tarif_class"]['filtr'][filtr_key][filtr_type] -= [""] 
                params["service_category_tarif_class"]['filtr'][filtr_key][filtr_type] = params["service_category_tarif_class"]['filtr'][filtr_key][filtr_type].map do |item|
                  (item.to_i == 0) ? item.constantize : item.to_i
                end.flatten
                  raise(StandardError, [
                    params["service_category_tarif_class"]['filtr']
                  ]) if false
              end
            end
          end        
        end
      end       

    end

  end
  
  def check_first_service_category
    result = [true, ""]
    case
    when params["service_category_tarif_class"]['service_category_one_time_id']      
      result = [false, "service_category_periodic_id or uniq_service_category are not blank, #{params}"] if !params["service_category_tarif_class"]['service_category_periodic_id'].blank? or 
        !params["service_category_tarif_class"]['uniq_service_category'].try(:values).try(:compact).blank?
    when params["service_category_tarif_class"]['service_category_periodic_id']      
      result = [false, "uniq_service_category is not blank, #{params}"] if !params["service_category_tarif_class"]['uniq_service_category'].try(:values).try(:compact).blank?
    else
      current_structure = Optimization::Global::Base::Structure
      global_categories_from_params(params["service_category_tarif_class"]['uniq_service_category']).each{|category| current_structure = current_structure.try(:[], category) }

      result = [false, "not all categories for uniq_service_category are chosen"] if current_structure != {}
    end
    result
  end
  
  def global_categories_from_params(uniq_service_category_params = {})
    result = []
    ['rouming', 'service', 'direction', 'partner'].each do |category|
      result << uniq_service_category_params[category].to_sym if uniq_service_category_params[category]
    end
    result
  end
  
  def transform_uniq_service_category_to_hash(uniq_service_category_as_str = "")
    categories_from_uniq_service_category_as_str = uniq_service_category_as_str.split("/")
    result = {}
    ['rouming', 'service', 'direction', 'partner'].each_with_index do |category, index|
      result[category] = categories_from_uniq_service_category_as_str[index]
    end
    result
  end

end
