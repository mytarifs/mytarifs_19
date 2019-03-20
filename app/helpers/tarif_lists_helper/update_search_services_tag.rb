module TarifListsHelper  
  class UpdateSearchServicesTag 
    def self.run(selected_tarif_class_id, search_services_tag = {})
      return if search_services_tag.blank?
      selected_tarif_class = TarifClass.where(:id => selected_tarif_class_id).first
      if selected_tarif_class
        selected_tarif_class.features ||= {}
        selected_tarif_class.features['search_services_tag'] ||= {}
        if search_services_tag['add_key'] == 'true'
          new_key = ((selected_tarif_class.features['search_services_tag'].keys.map(&:to_i).max || 0) + 1).to_s
          selected_tarif_class.features['search_services_tag'][new_key] = []
        end
        if search_services_tag['take_out_key'] == 'true' and !search_services_tag['key'].blank? and selected_tarif_class.features['search_services_tag'][search_services_tag['key']].blank?
          selected_tarif_class.features['search_services_tag'].extract!(search_services_tag['key'])
        end
        if search_services_tag['add_value'] == 'true' and !search_services_tag['key'].blank? and !search_services_tag['new_value'].blank?
          selected_tarif_class.features['search_services_tag'][search_services_tag['key']] ||= []
          selected_tarif_class.features['search_services_tag'][search_services_tag['key']] << search_services_tag['new_value']
          selected_tarif_class.features['search_services_tag'][search_services_tag['key']].uniq!
        end
        if search_services_tag['take_out_value'] == 'true' and !search_services_tag['key'].blank? and !search_services_tag['value'].blank?
          selected_tarif_class.features['search_services_tag'][search_services_tag['key']] ||= []
          selected_tarif_class.features['search_services_tag'][search_services_tag['key']] -= [search_services_tag['value']]
        end
        selected_tarif_class.save!
      end
    end
  end

end
