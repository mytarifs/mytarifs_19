module TarifListsHelper  
  class ProcessServiceListParsing 
    def self.run(process_service_list_parsing_params = {})
      return if process_service_list_parsing_params.try(:[], 'command').blank? or process_service_list_parsing_params.try(:[], 'params').blank?
      send(process_service_list_parsing_params['command'].to_sym, process_service_list_parsing_params['params'])
    end
    
    def self.add_tarif_class_for_parsing(params)
      existing_tarif_class = TarifClass.where(:id => params['existing_tarif_class_id'].try(:to_i)).first
      if existing_tarif_class
        new_tarif_class = TarifClass.new
        new_tarif_class.name = params['new_tarif_class_name']
        new_tarif_class.http = params['url']
        new_tarif_class.operator_id = existing_tarif_class.operator_id
        new_tarif_class.privacy_id = existing_tarif_class.privacy_id
        new_tarif_class.standard_service_id = existing_tarif_class.standard_service_id
        new_tarif_class.region_txt = existing_tarif_class.region_txt
        new_tarif_class.publication_status = Content::Article::PublishStatus[:draft]
        new_tarif_class.for_parsing = true
        new_tarif_class.is_archived = false
        new_tarif_class.excluded_from_optimization = true
        new_tarif_class.slug = nil
        new_tarif_class.save!
      end 
    end

    def self.add_new_service(params)
      existing_tarif_class = TarifClass.where(:id => params['existing_tarif_class_id'].try(:to_i)).first
      if existing_tarif_class
        new_tarif_class = TarifClass.new
        new_tarif_class.name = params['new_tarif_class_name']
        new_tarif_class.http = params['url']
        new_tarif_class.operator_id = existing_tarif_class.operator_id
        new_tarif_class.privacy_id = existing_tarif_class.privacy_id
        new_tarif_class.standard_service_id = existing_tarif_class.standard_service_id
        new_tarif_class.region_txt = existing_tarif_class.region_txt
        new_tarif_class.publication_status = Content::Article::PublishStatus[:draft]
        new_tarif_class.for_parsing = false
        new_tarif_class.is_archived = false
        new_tarif_class.excluded_from_optimization = true
        new_tarif_class.slug = nil
        new_tarif_class.save!
      end 
    end

    def self.skip_service_to_scrap(params)
      existing_tarif_class = TarifClass.where(:id => params['existing_tarif_class_id'].try(:to_i)).first
      if existing_tarif_class
        existing_tarif_class.services_to_skip_scrap ||= []
        existing_tarif_class.services_to_skip_scrap << params['skip_service_name']
        existing_tarif_class.services_to_skip_scrap.uniq!
        existing_tarif_class.save!
      end 
    end

    def self.cancel_skip_service_to_scrap(params)      
      existing_tarif_class = TarifClass.where(:id => params['existing_tarif_class_id'].try(:to_i)).first

      if existing_tarif_class
        parser = ServiceParser::Runner.init({:operator_id => existing_tarif_class.try(:operator_id), :original_page => ''})
        services_to_skip_scrap_to_exclude = []
        (existing_tarif_class.services_to_skip_scrap || []).each do |service_to_skip_scrap|
          if_to_exclude = (service_to_skip_scrap.try(:squish) == params['skip_service_name'].try(:squish))
          if_to_exclude = (if_to_exclude or (parser.normailze_name(service_to_skip_scrap.try(:squish)) == parser.normailze_name(params['skip_service_name'].try(:squish)))) if !if_to_exclude

          services_to_skip_scrap_to_exclude << service_to_skip_scrap if if_to_exclude 
        end
        existing_tarif_class.services_to_skip_scrap -= services_to_skip_scrap_to_exclude

        existing_tarif_class.save!
      end 
    end

    def self.force_exisitng_service_to_scrap(params)
      existing_tarif_class = TarifClass.where(:id => params['existing_tarif_class_id'].try(:to_i)).first
      if existing_tarif_class
        existing_tarif_class.services_to_force_scrap ||= []
        existing_tarif_class.services_to_force_scrap << params['to_force_service_name']
        existing_tarif_class.services_to_force_scrap.uniq!
        existing_tarif_class.save!
      end 
    end

    def self.cancel_force_exisitng_service_to_scrap(params)
      existing_tarif_class = TarifClass.where(:id => params['existing_tarif_class_id'].try(:to_i)).first
      if existing_tarif_class
        existing_tarif_class.services_to_force_scrap ||= []
        existing_tarif_class.services_to_force_scrap -= [params['to_force_service_name']]
        existing_tarif_class.save!
      end 
    end

    def self.add_exisitng_service_to_skip_parsing(params)
      skip_service_to_scrap(params)
    end

    def self.cancel_exisitng_service_to_skip_parsing(params)
      cancel_skip_service_to_scrap(params)
    end

  end

end
