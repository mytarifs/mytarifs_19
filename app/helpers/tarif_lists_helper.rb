module TarifListsHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::ArrayOfHashable, 
    SavableInSession::Tableable, SavableInSession::SessionInitializers
  
  def general_tarif_class_filtr
    create_filtrable("general_tarif_class")
  end
  
  def base_tarif_class_from_general_tarif_class_filtr
    filtr = session_filtr_params(general_tarif_class_filtr)
    operator_id = filtr['operator_id'].try(:to_i)
    standard_service_ids = ((filtr['standard_service_id'] || []) - ['']).map(&:to_i)
    privacy_ids = ((filtr['privacy_id'] || []) - ['']).map(&:to_i)
    model = TarifClass.where(:operator_id => operator_id)
    model = model.where(:standard_service_id => standard_service_ids) if !standard_service_ids.blank?
    model = model.where(:privacy_id => privacy_ids) if !privacy_ids.blank?
    model
  end
  
  def tarif_list_region_filtr
    create_filtrable("tarif_list_region")
  end
  
  def service_list_parsing_filtr
    create_filtrable("service_list_parsing")
  end
  
  def service_parsing_filtr
    create_filtrable("service_parsing")
  end
  
  def general_task_filtr
    create_filtrable("general_task")
  end

  def scraping_options_filtr
    create_filtrable("scraping_options")
  end
  
  def tarif_list_for_tarif_list_form
    filtr = session_filtr_params(tarif_list_region_filtr)    
    TarifList.includes(:tarif_class).where(:tarif_class_id => filtr['tarif_class_id'], :region_id => filtr['region_id']).first || TarifList.new
  end

  def tarif_list_form
    create_formable(tarif_list_for_tarif_list_form)
  end
  
  def tarif_list_for_service_list_parsing_form
    create_formable(tarif_list_for_tarif_list_form)
  end
  
  def tarif_list_for_service_parsing_form
    create_formable(tarif_list_for_tarif_list_form)
  end
  
  def service_list_parsing_table
    filtr = session[:filtr]['service_list_parsing_filtr'] || {} 
    tarif_list_filtr = session[:filtr]['tarif_list_region_filtr'] || {}
    tarif_class_filtr = session[:filtr]['general_tarif_class_filtr'] || {}    
    operator_id = tarif_class_filtr['operator_id'].try(:to_i)
    standard_service_id = ((tarif_class_filtr['standard_service_id'] || []) - [''])[0].try(:to_i)
    privacy_id = ((tarif_class_filtr['privacy_id'] || []) - [''])[0].try(:to_i)
    region_id = tarif_list_filtr['region_id'].try(:to_i)
    tarif_class_id_for_parsing = tarif_list_filtr['tarif_class_id'].blank? ? nil : tarif_list_filtr['tarif_class_id'].try(:to_i)
    source_for_search = tarif_list_filtr['source_for_search'].blank? ? nil : tarif_list_filtr['source_for_search'] 
    include_only_services_from_scrap = tarif_list_filtr['include_only_services_from_scrap'].blank? ? false : true

    real_tarif_list = tarif_list_for_tarif_list_form.id ? tarif_list_for_tarif_list_form : nil

    unscrapped_services_results = []
    chosen_scrap_statuses = (((filtr['scrap_status'] || []) - ['']) || []).map(&:to_i)
    chosen_to_scrap_statuses = (((filtr['to_scrap_status'] || []) - ['']) || []).map(&:to_i)
    chosen_scrap_management_buttons = (((filtr['scrap_management_buttons'] || []) - ['']) || []).map(&:to_sym)
    
    search_unscrapped_services_results = if tarif_list_filtr['region_id'].blank?
      ::Scraper::SearchServices.search_unscrapped_services_from_services_hash_for_all_regions(operator_id, privacy_id, standard_service_id, tarif_class_id_for_parsing, source_for_search)
    else
      if ['current_to_scrap_services', 'prev_to_scrap_services'].include?(source_for_search)
        ::Scraper::SearchServices.saved_to_scrap_services_by_region(region_id, operator_id, privacy_id, standard_service_id, tarif_class_id_for_parsing, source_for_search)
      else
        ::Scraper::SearchServices.search_unscrapped_services_from_services_hash(region_id, operator_id, privacy_id, standard_service_id, tarif_class_id_for_parsing, include_only_services_from_scrap)
      end
    end

    search_unscrapped_services_results.map do |key, value|
        next if filtr['unequal_links'] == 'true' and value[:links_are_equal] == true
        next if !chosen_scrap_statuses.blank? and !chosen_scrap_statuses.include?(value[:scrap_status])
        next if !chosen_to_scrap_statuses.blank? and !chosen_to_scrap_statuses.include?(value[:to_scrap_status])
        next if !chosen_scrap_management_buttons.blank? and (chosen_scrap_management_buttons & value[:buttons]).blank?
        unscrapped_services_results << value.merge({:service_name => key.to_s})
      end      
    unscrapped_services_results.sort_by!{|r| r[:scrap_status].try(:to_s) + r[:service_name]} if unscrapped_services_results.blank?

#    unscrapped_services_results = [{}]
    options = {:base_name => 'service_list_parsing_table', :current_id_name => ':original_name', :id_name => ':original_name', 
        :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 225)}
    create_array_of_hashable(unscrapped_services_results, options)
  end
  
  def tarif_list_collection_filtr
    create_filtrable("tarif_list_collection")
  end
  
  def base_tarif_list_collection_model
    tarif_class_filtr = session[:filtr]['general_tarif_class_filtr'] || {}    
    operator_id = tarif_class_filtr['operator_id'].try(:to_i)
    standard_service_ids = ((tarif_class_filtr['standard_service_id'] || []) - ['']).map(&:to_i)
    privacy_ids = ((tarif_class_filtr['privacy_id'] || []) - ['']).map(&:to_i)
    base_tarif_class = base_tarif_class_from_general_tarif_class_filtr
    base_tarif_class = base_tarif_class.for_parsing(tarif_class_filtr['for_parsing']) if !tarif_class_filtr['for_parsing'].blank?
    
    TarifList.includes(:tarif_class, :region).joins(:tarif_class).where(:tarif_class_id => base_tarif_class.pluck(:id).uniq)
  end

  def tarif_list_collection
    tarif_list_collection_filtr = session[:filtr]['tarif_list_collection_filtr'] || {}
    
    model = base_tarif_list_collection_model
      
    model = model.where(:region_id => tarif_list_collection_filtr['region_id'].try(:to_i)) if !tarif_list_collection_filtr['region_id'].blank?
    model = model.where(:tarif_class_id => tarif_list_collection_filtr['tarif_class_id'].try(:to_i)) if !tarif_list_collection_filtr['tarif_class_id'].blank?
    model = model.where("(tarif_lists.features#>>'{initial_processing, h1}')::text is null") if tarif_list_collection_filtr['show_only_empty_h1'] == 'true'
    model = model.where("(tarif_lists.features->>'status')::integer in (#{tarif_list_collection_filtr['status'].join(', ')})") if !((tarif_list_collection_filtr['status'] || []) - ['']).blank?
    model = model.where("(tarif_lists.features->>'status')::integer is null") if tarif_list_collection_filtr['show_null_status'] == 'true'
    model = model.where("(tarif_lists.features->>'tarif_list_for_parsing_ids')::jsonb is null or (tarif_lists.features->>'tarif_list_for_parsing_ids')::jsonb = '[]'") if 
      tarif_list_collection_filtr['show_empty_tarif_list_for_parsing_ids'] == 'true'
    model = model.order("tarif_classes.name, tarif_lists.region_id")

    options = {:base_name => 'tarif_list_collection', :current_id_name => 'tarif_list_collection_id', :pagination_per_page => (tarif_list_collection_filtr['row_per_page'].try(:to_i) || 25)}
    create_tableable(model, options)    
  end
  
  def scraped_info_from_tarif_list_for_parsing_filtr
    create_filtrable("scraped_info_from_tarif_list_for_parsing")
  end
  
  def base_tarif_lists_for_scraped_info
    filtr = session[:filtr]['scraped_info_from_tarif_list_for_parsing_filtr'] || {}
    
    base_tarif_class_ids = case
    when !filtr['tarif_classes_for_parsing_id'].blank?; [filtr['tarif_classes_for_parsing_id']].flatten.compact.map(&:to_i);
    else base_tarif_class_from_general_tarif_class_filtr.for_parsing('true').pluck(:id).uniq;
    end
    
    base_tarif_lists = TarifList.includes(:tarif_class, :region).joins(:tarif_class).where(:tarif_class_id => base_tarif_class_ids)      
    base_tarif_lists = base_tarif_lists.where(:region_id => filtr['region_id'].try(:to_i)) if !filtr['region_id'].blank?
    base_tarif_lists
  end
  
  def scraped_info_from_tarif_list_for_parsing
    filtr = session[:filtr]['scraped_info_from_tarif_list_for_parsing_filtr'] || {}
    
    scraped_info = []
    
    base_tarif_lists_for_scraped_info.each do |tarif_list_for_parsing|
      (tarif_list_for_parsing.current_scraped_services || {}).each do |normalized_service_name, scraped_service_info|
        base_tarif_class_ids = tarif_list_for_parsing.current_to_scrap_services.try(:[], normalized_service_name).try(:[], 'all_exisitng_services_value').try(:[], 'ids') || []
        next if !base_tarif_class_ids.include?(filtr['base_tarif_classes_id'].try(:to_i)) if !filtr['base_tarif_classes_id'].blank?
        next if filtr['show_only_empty_h1'] == 'true' and !scraped_service_info.try(:[], 'initial_processing').try(:[], 'h1').blank?
        filtred_statuses = ((filtr['status'] || []) - ['']).map(&:to_i)
        next if !filtred_statuses.blank? and !filtred_statuses.include?(scraped_service_info.try(:[], 'status').try(:to_i))
        next if filtr['show_null_status'] == 'true' and !scraped_service_info.try(:[], 'status').nil?

        urls_name = [true, 'true'].include?(tarif_list_for_parsing.tarif_class.for_existing_servises) ? 'tarif_class_url' : 'services_to_scrap_urls'
        scraped_info << (scraped_service_info || {}).merge({
          'original_name' => tarif_list_for_parsing.current_to_scrap_services.try(:[], normalized_service_name).try(:[], 'original_name'), 
          'urls' => tarif_list_for_parsing.current_to_scrap_services.try(:[], normalized_service_name).try(:[], urls_name), 
          'normalized_name' => normalized_service_name, 
          'region_id' => tarif_list_for_parsing.region_id,
          'region_name' => tarif_list_for_parsing.region.try(:name),
          'tarif_class_id' => tarif_list_for_parsing.tarif_class.try(:id),
          'tarif_class_name' => tarif_list_for_parsing.tarif_class.try(:name),
          'operator_id' => tarif_list_for_parsing.tarif_class.try(:operator_id),
          'privacy_id' => tarif_list_for_parsing.tarif_class.try(:privacy_id),
        })
      end
    end
    
    scraped_info = [{}] if scraped_info.blank?
    
    options = {:base_name => 'scraped_info_from_tarif_list_for_parsing', 
      :current_id_name => 'scraped_info_from_tarif_list_for_parsing_id', :id_name => 'normalized_name', 
      :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_array_of_hashable(scraped_info, options)    
  end
  
  def process_tarif_list_collection_filtr
    filtr = params['tarif_list_collection_filtr']

    if filtr.try(:[], 'scrap_filtered_tarif_list') == 'true'
      tarif_list_ids_to_delete = []      
      tarif_list_collection.model.map do |tl|
        tc = tl.tarif_class         
        tl_normalized_name = ServiceParser::Base.new({}).normailze_name(tl.tarif_class.name)
        if tl.tarif_list_for_parsing_ids.blank?
          to_update_saved_to_scrap_services = false          
          search_unscrapped_services = Scraper::SearchServices.saved_to_scrap_services_by_region(
            tl.region_id, tc.operator_id, tc.privacy_id, tc.standard_service_id, nil, 'current_to_scrap_services')
          if search_unscrapped_services[tl_normalized_name].blank?
            search_unscrapped_services = Scraper::SearchServices.search_unscrapped_services_from_services_hash(
              tl.region_id, tc.operator_id, tc.privacy_id, tc.standard_service_id, nil, false)
            to_update_saved_to_scrap_services = true if search_unscrapped_services[tl_normalized_name]
          end
          
          next if search_unscrapped_services[tl_normalized_name].blank?

          base_tarif_class_ids = search_unscrapped_services[tl_normalized_name][:services_to_scrap_value].try(:[], :base_tarif_classes)
          base_tarif_class_ids = [search_unscrapped_services[tl_normalized_name][:all_exisitng_services_value].
            try(:[], :tarif_class_id_for_exisitng_services_to_skip_parsing)] if base_tarif_class_ids.blank?

          if !base_tarif_class_ids.blank?
            base_tarif_list_for_parsing = TarifList.where(:region_id => tl.region_id, :tarif_class_id => base_tarif_class_ids).first
            if base_tarif_list_for_parsing
              tl.tarif_list_for_parsing_ids = [base_tarif_list_for_parsing.id]
              tl.save!
              
              puts "updating #{base_tarif_list_for_parsing.attributes.except('description')}"
              Scraper::SearchServices.update_saved_services_to_scrap_for_one_tarif_list_for_parsing(base_tarif_list_for_parsing)
            end
          end
        end
                        
        if !tl.tarif_list_for_parsing_ids.blank?
          chosen_services_to_scrap = [ServiceParser::Base.new({}).normailze_name(tl.tarif_class.name)]
          tarif_list_for_parsing_to_scrap = TarifList.where(:id => tl.tarif_list_for_parsing_ids).first
          force_to_scrap = filtr.try(:[], 'force_to_scrap') == 'true' ? true : false
          raise(StandardError, [
            tl.tarif_list_for_parsing_ids,
            tl.attributes.except('description'),
            tarif_list_for_parsing_to_scrap.current_to_scrap_services[tl_normalized_name],
          ]) if false
          Scraper::Service.scrap_tarif_list_for_parsing(tarif_list_for_parsing_to_scrap, {}, chosen_services_to_scrap, force_to_scrap)
        else
          tarif_list_ids_to_delete << tl.id
        end
      end

      raise(StandardError, [
        tarif_list_ids_to_delete
      ]) if false and !tarif_list_ids_to_delete.blank?
    end  
  end

  def process_scraped_info_from_tarif_list_for_parsing_filtr
    filtr = params['scraped_info_from_tarif_list_for_parsing_filtr']

    if filtr.try(:[], 'scrap_filtered_services_to_scrap') == 'true'
      chosen_services_to_scrap = scraped_info_from_tarif_list_for_parsing.model.map{|scraped_info| scraped_info['normalized_name']}
      force_to_scrap = filtr.try(:[], 'force_to_scrap') == 'true' ? true : false
      
      base_tarif_lists_for_scraped_info.each do |tarif_list_for_parsing|
        Scraper::Service.scrap_tarif_list_for_parsing(tarif_list_for_parsing, {}, chosen_services_to_scrap, force_to_scrap)
      end
    end
  end

  def update_search_services_tag
    selected_tarif_class_id = session[:filtr]['tarif_list_region_filtr'].try(:[], 'tarif_class_id').try(:to_i)
    search_services_tag = params['service_list_parsing_filtr'].try(:[], 'search_services_tag')
    TarifListsHelper::UpdateSearchServicesTag.run(selected_tarif_class_id, search_services_tag) 
  end
  
  def process_service_list_parsing
    TarifListsHelper::ProcessServiceListParsing.run(params['process_service_list_parsing'])
  end
  
  def general_task_runner
    filtr = params['general_task_filtr']
    scraping_options = session[:filtr]['scraping_options_filtr'] || {}
    options = {}
    if !filtr.blank?
      ['region_id', 'operator_id', 'privacy_id', 'standard_service_id'].each{|key| options[key] = (filtr[key] - ['']).map(&:to_i)} 
      options[:calculate_on_background] = scraping_options['calculate_on_background']
      options[:force_to_scrap] = filtr['force_to_scrap']
    end
    
    raise(StandardError, [
      options
    ]) if false

    Scraper::Service.run_scraper(options) if filtr.try(:[], 'run_full_scraper_for_tarif_list') == 'true'
    Scraper::Service.run_tarif_classes_for_parsing(options) if filtr.try(:[], 'run_tarif_classes_for_parsing') == 'true'      
    Scraper::SearchServices.update_saved_services_to_scrap_for_all_regions(options, false) if filtr.try(:[], 'update_services_to_scrap_for_all_regions') == 'true'      
    Scraper::SearchServices.update_saved_services_to_scrap_for_all_regions(options, true) if filtr.try(:[], 'update_only_new_services_to_scrap_for_all_regions') == 'true'      
  end

  def reload_page_from_operator_tarif_list
    filtr = params['tarif_list_region_filtr']
    tarif_class_filtr = session[:filtr]['general_tarif_class_filtr'] || {}    
    scraping_options = session_filtr_params(scraping_options_filtr)
    scraping_options ||= {} #to init scraping_options 
    if filtr.try(:[], 'reload_page_from_operator') == 'true'# and !tarif_list_for_tarif_list_form.visited_page_url.blank?
      service = TarifClass.where(:id => tarif_list_for_tarif_list_form.tarif_class_id).first
      if service
        puts
        puts "running reload_page_from_operator_tarif_list"
#        puts "service #{service.attributes}"
        puts
        tarif_list = TarifList.find_or_create_by(:tarif_class_id => service.id, :region_id => filtr['region_id'].try(:to_i))
        page_info = Scraper::Service.scrap_service(tarif_class_filtr['operator_id'].try(:to_i), filtr['region_id'].try(:to_i), service, 
          {:use_selenium => scraping_options['use_selenium'], :force_to_scrap => true})
        tarif_list.update(page_info) if page_info
        Scraper::SearchServices.update_saved_services_to_scrap_for_one_tarif_list_for_parsing(tarif_list)
      end
    end
    
    if filtr.try(:[], 'update_saved_services_to_scrap') == 'true'
      service = TarifClass.where(:id => filtr['tarif_class_id'].try(:to_i)).for_parsing('true').first
      if service
        tarif_lists_for_parsing = TarifList.where(:tarif_class_id => service.id)
        tarif_lists_for_parsing = tarif_lists_for_parsing.where(:region_id => filtr['region_id'].try(:to_i)) if !filtr['region_id'].blank?
        tarif_lists_for_parsing.each do |tarif_list_for_parsing|
          Scraper::SearchServices.update_saved_services_to_scrap_for_one_tarif_list_for_parsing(tarif_list_for_parsing)
        end
      end
    end
    
  end
  


end
