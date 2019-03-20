module TarifClassesHelper  
  class ProcessParsedTarifLists 
    def self.run(command, filtr = {}, tarif_class_filtr = {})
      return if command.blank?
      send(command.to_sym, filtr, tarif_class_filtr)
    end
    
    def self.save_parsed_service_for_filtered_tarif_list(filtr, tarif_class_filtr)
      region_ids = ((filtr['region_id'] || []) - ['']).map(&:to_i)
      parsed_tarif_classes = if tarif_class_filtr['tarif_class_id'].blank?
        TarifClass.
          where(:operator_id => tarif_class_filtr['operator_id'].try(:to_i)).
          where(:standard_service_id => tarif_class_filtr['standard_service_id'].try(:to_i)).
          where(:privacy_id => tarif_class_filtr['privacy_id'].try(:to_i))
      else
        TarifClass.where(:id => tarif_class_filtr['tarif_class_id'].try(:to_i))
      end
      
      parsed_tarif_classes.each do |parsed_tarif_class|
        model = TarifList.includes(:tarif_class, :region).joins(:tarif_class).where(:tarif_class_id => parsed_tarif_class.try(:id))
        model = model.where(:region_id => region_ids) if !region_ids.blank?
        
        model.each do |tarif_list|
          parser = ServiceParser::Runner.init({
            :operator_id => tarif_list.try(:tarif_class).try(:operator_id),
            :region_id => tarif_list.try(:region_id),
            :tarif_class => tarif_list.try(:tarif_class),
            :parsing_class => tarif_list.try(:tarif_class).try(:parsing_class),
            :original_page => tarif_list.description,
          })
          tarif_list.prev_saved_service_desc = tarif_list.current_saved_service_desc
          tarif_list.current_saved_service_desc = parser.parse_service
          tarif_list.save
        end
      end
    end

  end

end
