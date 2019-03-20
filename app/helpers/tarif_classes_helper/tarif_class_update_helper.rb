module TarifClassesHelper::TarifClassUpdateHelper

  def check_tarif_class_params_before_update
    if params["tarif_class"]
      params["tarif_class"]["operator_id"] = nil if params["tarif_class"]["operator_id"].blank?
      params["tarif_class"]['features']["region_txt"] = nil if params["tarif_class"]['features']["region_txt"].blank?
      params["tarif_class"]["slug"] = nil if params["tarif_class"]["slug"].blank?
      params["tarif_class"]['features']["publication_status"] = params["tarif_class"]['features']["publication_status"].try(:to_i)
      params["tarif_class"]['features']["allowed_option_for_children"] = params["tarif_class"]['features']["allowed_option_for_children"] == "true" ? true : false
      params["tarif_class"]['features']["tv_video_content"] = nil if params["tarif_class"]['features']["tv_video_content"].blank?
      params["tarif_class"]['features']["contract_sharing_with_other_devices"] = nil if params["tarif_class"]['features']["contract_sharing_with_other_devices"].blank?
      params["tarif_class"]['features']["phone_must_have_3g_or_4g"] = params["tarif_class"]['features']["phone_must_have_3g_or_4g"] == "true" ? true : false
      params["tarif_class"]['features']["only_mobile_phone"] = params["tarif_class"]['features']["only_mobile_phone"] == "true" ? true : false
      params["tarif_class"]['features']["limited_trafic_to_file_nets"] = params["tarif_class"]['features']["limited_trafic_to_file_nets"] == "true" ? true : false
      params["tarif_class"]['features']["limited_speed"] = nil if params["tarif_class"]['features']["limited_speed"].blank?
      params["tarif_class"]['features']["limited_time_of_day"] = nil if params["tarif_class"]['features']["limited_time_of_day"].blank?
      params["tarif_class"]['features']["recommended_for_planshet"] = params["tarif_class"]['features']["recommended_for_planshet"] == "true" ? true : false
      params["tarif_class"]['features']["internet_sharing_with_other_devices"] = params["tarif_class"]['features']["internet_sharing_with_other_devices"] == "true" ? true : false
      params["tarif_class"]['features']["available_only_for_pencioner"] = params["tarif_class"]['features']["available_only_for_pencioner"] == "true" ? true : false
      params["tarif_class"]['features']["excluded_from_optimization"] = params["tarif_class"]['features']["excluded_from_optimization"] == "true" ? true : false
      params["tarif_class"]['features']["for_parsing"] = params["tarif_class"]['features']["for_parsing"] == "true" ? true : false
      params["tarif_class"]['features']["for_existing_servises"] = params["tarif_class"]['features']["for_existing_servises"] == "true" ? true : false
      params["tarif_class"]['features']["has_parsing_class"] = params["tarif_class"]['features']["has_parsing_class"] == "true" ? true : false
      params["tarif_class"]['features']["parsing_class"] = nil if !params["tarif_class"]['features']["has_parsing_class"]
      params["tarif_class"]['features']["regions"] = ((params["tarif_class"]['features']["regions"] || []) - ['']).map(&:to_i)
      params["tarif_class"]['features']["archived_regions"] = ((params["tarif_class"]['features']["archived_regions"] || []) - ['']).map(&:to_i)
 

      params["tarif_class"]['dependency']["incompatibility"] ||= {}
      params["tarif_class"]['dependency']["incompatibility_keys"] ||= {}
      if !params["tarif_class"]['dependency']["new_incompatibility_key"].blank?
        params["tarif_class"]['dependency']["incompatibility"][params["tarif_class"]['dependency']["new_incompatibility_key"]] ||= []
        params["tarif_class"]['dependency']["new_incompatibility_key"] = nil
      end
      params["tarif_class"]['dependency']["incompatibility_keys"].each do |key, value|
        params["tarif_class"]['dependency']["incompatibility"].extract!(key) if value.blank?
      end       

      params["tarif_class"]['dependency']["incompatibility"].each do |key, value|
        params["tarif_class"]['dependency']["incompatibility"][key]-= [""]
      end       

      params["tarif_class"]['dependency']["general_priority"] = params["tarif_class"]['dependency']["general_priority"].try(:to_i)
      
      params["tarif_class"]['dependency']["other_tarif_priority"] ||= {}
      params["tarif_class"]['dependency']["other_tarif_priority"]['lower'] ||= []
      params["tarif_class"]['dependency']["other_tarif_priority"]['lower'] -= [""]
      params["tarif_class"]['dependency']["other_tarif_priority"]['higher'] ||= []
      params["tarif_class"]['dependency']["other_tarif_priority"]['higher'] -= [""]

      params["tarif_class"]['dependency']["parts"] = (tarif_class.dependency || {})['parts']

      params["tarif_class"]['dependency']["prerequisites"] ||= []
      params["tarif_class"]['dependency']["prerequisites"] -= [""]

      params["tarif_class"]['dependency']["forbidden_tarifs"] ||= {}
      params["tarif_class"]['dependency']["forbidden_tarifs"]['to_switch_on'] ||= []
      params["tarif_class"]['dependency']["forbidden_tarifs"]['to_switch_on'] -= [""]
      params["tarif_class"]['dependency']["forbidden_tarifs"]['to_serve'] ||= []
      params["tarif_class"]['dependency']["forbidden_tarifs"]['to_serve'] -= [""]

      params["tarif_class"]['dependency']["multiple_use"] = params["tarif_class"]['dependency']["multiple_use"] == "true" ? true : false
      params["tarif_class"]['dependency']["is_archived"] = params["tarif_class"]['dependency']["is_archived"] == "true" ? true : false
      
      params["tarif_class"]['features']["phone_number_type"] ||= []
      params["tarif_class"]['features']["phone_number_type"] -= [""]
              
      params["tarif_class"]['features']["http"] = nil if params["tarif_class"]['features']["http"].blank?
      params["tarif_class"]['features']["buy_http"] = nil if params["tarif_class"]['features']["buy_http"].blank?

      raise(StandardError, [
        params["tarif_class"]['dependency']
      ]) if false
    end
  end
  
end
