module ServiceParser
   
  module GlobalCategoryHelper
    
    def search_global_categories(block_title, sub_block_title, original_params = {})
      result = {}
      
      params = substitute_blank_param_value(original_params)

      params = split_params_into_independent_rouming_destination_and_to_operator_parts(params)
      
      params.each do |param_name, param_value|
        descriptions = {:param_name => param_name, :sub_block_title => sub_block_title, :block_title => block_title}
        search_global_category(descriptions).each do |global_category|
          result[global_category] ||= []
          result[global_category] << {
            'service_desc_group_name' => block_title,
            'service_desc_sub_group_name' => sub_block_title,
            'field_name' => param_name,
            'param_value' => param_value
          }
        end
      end
      result
    end
    
    def search_global_category(descriptions = {})
      result = [[]]
      return [[:incomplete, :no_description]] if descriptions.blank?
      
      tarif_payment = search_one_global_category(service_to_global_category_attributes[:tarif_payments], descriptions)
      return [[:complete, :tarif_payments, tarif_payment]] if tarif_payment

      is_included_in_tarif = search_one_global_category(service_to_global_category_attributes[:included_in_tarif], descriptions)
      return [[:complete, :included_in_tarif, is_included_in_tarif]] if [:tarif_scope, :neighbour_home_region].include?(is_included_in_tarif)
      is_included_in_tarif = :over_included_in_tarif if is_included_in_tarif.blank?
      result[0] << is_included_in_tarif

      rouming = search_multiple_global_categories(service_to_global_category_attributes[:rouming], descriptions)
      result = add_multiple_global_category_part_by_one_in_sub_result(result, rouming) if rouming
      result[0] << :tarif_rouming if rouming.blank?

      service_direction = search_multiple_global_categories(service_to_global_category_attributes[:service_direction], descriptions.slice(:param_name))
      service_direction = search_multiple_global_categories(service_to_global_category_attributes[:service_direction], descriptions.slice(:sub_block_title)) if service_direction.blank?
      raise(StandardError, [
        service_direction
      ]) if false and descriptions.values.join(' ') =~ /Бесплатные входящие вызовы по России/i
      service_direction = [:outcoming] if service_direction.blank?

      service_type = []
      if service_direction and service_direction.include?(:incoming)
        service_type << search_one_global_category(service_to_global_category_attributes[:service_type][:incoming], descriptions.slice(:param_name, :sub_block_title))
        service_type = (service_type - ['']).compact.uniq
        service_type << search_one_global_category(service_to_global_category_attributes[:service_type][:incoming].slice(:calls_in), descriptions.slice(:sub_block_title)) if service_type.blank?
        service_type = (service_type - ['']).compact.uniq

        multiple_incoming_service_type = search_multiple_global_categories(service_to_global_category_attributes[:service_type][:multiple_incoming], descriptions.slice(:param_name)) if service_type.blank?
        service_type += multiple_incoming_service_type if !multiple_incoming_service_type.blank?
        service_type = (service_type - ['']).compact.uniq
      end
      
      if service_direction and service_direction.include?(:outcoming)
        multiple_outcoming_service_type = search_multiple_global_categories(service_to_global_category_attributes[:service_type][:multiple_outcoming], descriptions.slice(:param_name))
        service_type += multiple_outcoming_service_type if !multiple_outcoming_service_type.blank?
        service_type = (service_type - ['']).compact.uniq
      end
      
      if service_direction and service_direction.include?(:outcoming)
        raise(StandardError, [
          service_type
        ]) if false and descriptions[:block_title] =~ /SMS за границей/i
        service_type << search_one_global_category(service_to_global_category_attributes[:service_type][:outcoming], descriptions.slice(:param_name, :sub_block_title))
        service_type = (service_type - ['']).compact.uniq
        service_type << search_one_global_category(service_to_global_category_attributes[:service_type][:outcoming].slice(:calls_out), descriptions.slice(:sub_block_title)) if service_type.blank?
        service_type = (service_type - ['']).compact.uniq
        service_type << search_one_global_category(service_to_global_category_attributes[:service_type][:outcoming].slice(:calls_out, :sms_out, :internet), {:joined_description => descriptions.values.join(' ')}) if service_type.blank?
        service_type = (service_type - ['']).compact.uniq
      end
      
      service_type = (service_type - ['']).compact.uniq
      

      result = add_multiple_global_category_part_by_one_in_sub_result(result, service_type) if !service_type.blank?
      
      result.each do |result_item|
        raise(StandardError, [
          result
        ]) if false and result_item[2].blank?
      end
      
      if true or (service_type & [:internet, :calls_in, :sms_in, :mms_in]).blank?
        service_destination = search_multiple_global_categories(service_to_global_category_attributes[:service_destination][:russia_rouming], descriptions)
        if service_type.blank? and service_destination == [:to_abroad_countries]
          service_type = search_one_global_category(service_to_global_category_attributes[:service_type][:outcoming].slice(:calls_out), {:joined_description => descriptions.values.join(' ')})
          service_type = :calls_out if !service_type
          result.each{|sr| sr << service_type} if service_type
        end
        raise(StandardError, [
          service_destination
        ]) if false and descriptions.values.join(' ') =~ /Международная связь в поездках по России/i
        result = add_multiple_global_category_part_by_one_in_sub_result(result, service_destination) if service_destination

        service_destination = search_multiple_global_categories(service_to_global_category_attributes[:service_destination][:abroad_rouming], descriptions)
        result = add_multiple_global_category_part_by_one_in_sub_result(result, service_destination) if service_destination

        partner_type = search_multiple_global_categories(service_to_global_category_attributes[:partner_type][:to_operators], descriptions)
        result = add_multiple_global_category_part_by_one_in_sub_result(result, partner_type) if partner_type  

        partner_type = search_multiple_global_categories(service_to_global_category_attributes[:partner_type][:chosen_phone_number], descriptions)
        result = add_multiple_global_category_part_by_one_in_sub_result(result, partner_type) if partner_type  
      end
      
      result = check_result_for_completeness(result)

      result = [[:incomplete, :unknown]] if result == [[]]

      result
    end
    
    def substitute_blank_param_value(original_params)
      return original_params if service_to_global_category_attributes[:blank_param_value_substitutes].blank?
      
      original_params.each do |original_param_name, original_param_value|        
        if false and original_param_name =~ /Бесплатные звонки/i
          raise(StandardError)
          puts
          puts original_param_value.to_s
          puts
        end
        next if !(original_param_value.blank? or [['blank'], 'blank', [""]].include?(original_param_value)) 
        
        service_to_global_category_attributes[:blank_param_value_substitutes].each do |search_regexs, value_to_substitute|
          search_regexs.each do |search_regex|
            if search_regex =~ original_param_name
              original_params[original_param_name] = [value_to_substitute]
              break
            end              
          end
          break if !original_params[original_param_name].blank?
        end
      end 
      original_params
    end
    
    def split_params_into_independent_rouming_destination_and_to_operator_parts(original_params = {})
      return original_params if service_to_global_category_attributes[:split_params].try(:[], :param_name).blank?

      params = {}
      original_params.each do |original_param_name, original_param_value|
        scopes = original_param_name.split(service_to_global_category_attributes[:split_params][:param_name][:scope])
        if scopes.size <= 1
          params[original_param_name] = original_param_value
        else
          first_scope = scopes[0]
          service_to_global_category_attributes[:split_params][:param_name][:words_to_exclude_from_first_scope].each do |word_to_exclude|
            first_scope.gsub!(word_to_exclude, '')
          end
          scopes[1..-1].each do |scope|
            subscopes = scope.split(service_to_global_category_attributes[:split_params][:param_name][:scope_part])
            subscopes.each do |subscope|
              new_param_name = [first_scope, subscope].join(service_to_global_category_attributes[:split_params][:param_name][:scope_join])
              params[new_param_name] = original_param_value
            end
          end
        end
      end 
      params
    end
    
    def search_multiple_global_categories(search_attributes, descriptions)
      result = []
      descriptions.each do |key, description|        
        search_attributes.each do |global_key, search_attrs_by_global_key|
          search_attrs_by_global_key.each do |search_attr|
            result << global_key if description =~ search_attr  
          end
        end
      end
      result.blank? ? nil : result.uniq
    end
    
    def search_one_global_category(search_attributes, descriptions)
      descriptions.each do |key, description|        
        search_attributes.each do |global_key, search_attrs_by_global_key|
          search_attrs_by_global_key.each do |search_attr|
            return global_key if description =~ search_attr  
          end
        end
      end
      nil
    end
    
    def add_multiple_global_category_part_by_one_in_sub_result(result, multiple_global_category_part)
      new_result = []
      multiple_global_category_part.each do |one_global_category_part|
        result.each do |result_item|
          new_result << (result_item + [one_global_category_part])
        end            
      end 
      new_result
    end
    
    def check_result_for_completeness(result)
      new_result = []
      correct_size_of_complete_result_item = {
        :calls_in => 3, :sms_in => 3, :mms_in => 3, :sms_out => 4, :mms_out => 3, :internet => 3, :to_abroad_countries => 4, :other => 5, 
        :abroad_countries => {:sms_out => 2, :mms_out => 2, :internet => 2}, 
        :own_country_regions => {:calls_out => 4, :sms_out => 3, :mms_out => 3},
        :to_contract_numbers => 3,
        :to_tarif_numbers => 3,
      }
      result.each do |result_item|        
        completeness_tag = if_result_is_complete(result_item) ? :complete : :incomplete
        new_result << ([completeness_tag] + result_item)
      end
      new_result
    end

    def if_result_is_complete(result_item)
      correct_size_of_complete_result_item = {
        :calls_in => 3, :sms_in => 3, :mms_in => 3, :sms_out => 4, :mms_out => 3, :internet => 3, :to_abroad_countries => 4, :other => 5, 
        :abroad_countries => {:sms_out => 2, :mms_out => 2, :internet => 2}, 
        :own_country_regions => {:calls_out => 4, :sms_out => 3, :mms_out => 3},
        :to_contract_numbers => 3,
        :to_tarif_numbers => 3,
      }
      completeness = case
      when (result_item[1] == :own_country_regions and result_item[2] == :calls_out)
        result_item.size >= correct_size_of_complete_result_item[:own_country_regions][:calls_out]
      when (result_item[1] == :own_country_regions and result_item[2] == :sms_out)
        result_item.size >= correct_size_of_complete_result_item[:own_country_regions][:sms_out]
      when (result_item[1] == :own_country_regions and result_item[2] == :mms_out)
        result_item.size >= correct_size_of_complete_result_item[:own_country_regions][:mms_out]
      when (result_item[1] == :abroad_countries and result_item[2] == :sms_out)
        result_item.size >= correct_size_of_complete_result_item[:abroad_countries][:sms_out]
      when (result_item[1] == :abroad_countries and result_item[2] == :mms_out)
        result_item.size >= correct_size_of_complete_result_item[:abroad_countries][:mms_out]
      when (result_item[1] == :abroad_countries and result_item[2] == :internet)
        result_item.size >= correct_size_of_complete_result_item[:abroad_countries][:internet]
      when result_item[2] == :calls_in
        result_item.size >= correct_size_of_complete_result_item[:calls_in]
      when result_item[2] == :sms_in
        result_item.size >= correct_size_of_complete_result_item[:sms_in]
      when result_item[2] == :mms_in
        result_item.size >= correct_size_of_complete_result_item[:mms_in]
      when result_item[2] == :internet
        result_item.size >= correct_size_of_complete_result_item[:internet]
      when result_item[2] == :sms_out
        result_item.size >= correct_size_of_complete_result_item[:sms_out]
      when result_item[2] == :mms_out
        result_item.size >= correct_size_of_complete_result_item[:mms_out]
      when result_item[3] == :to_abroad_countries
        result_item.size >= correct_size_of_complete_result_item[:to_abroad_countries]
      when result_item[3] == :to_contract_numbers
        result_item.size >= correct_size_of_complete_result_item[:to_contract_numbers]
      when result_item[3] == :to_tarif_numbers
        result_item.size >= correct_size_of_complete_result_item[:to_tarif_numbers]
      else
        result_item.size >= correct_size_of_complete_result_item[:other]
      end
      completeness
    end
    
  end

end