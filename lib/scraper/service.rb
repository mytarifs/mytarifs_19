module Scraper 
  class Service
    
    def self.scraper(options = {})
      @scraper ||= Scraper::WebScraper.new(options)
    end
    
    #Scraper::Service.run_tarif_classes_for_parsing
    def self.run_tarif_classes_for_parsing(options = {})
      force_to_scrap = options[:force_to_scrap] || options['force_to_scrap']
      runner_by_region_operator_pivacy_and_standard_service(options) do |region_id, region_prefix, operator_id, privacy_id, standard_service_id|
        tarif_classes_for_parsing(region_id, operator_id, privacy_id, standard_service_id, force_to_scrap).each do |service|
          tarif_list = TarifList.find_or_create_by(:tarif_class_id => service.id, :region_id => region_id)
          next if service.for_existing_servises == true
          next if !tarif_list.features.try(:[], 'initial_processing').try(:[], 'h1').blank? and ![true, 'true'].include?(force_to_scrap)
          
          page_info = scrap_service(operator_id, region_id, service, options)
          tarif_list.update(page_info) if page_info
          
          Scraper::SearchServices.update_saved_services_to_scrap_for_one_tarif_list_for_parsing(tarif_list)

          sleep 1.0
        end
      end
    end
    
    #Scraper::Service.run_scraper
    def self.run_scraper(options = {})
      background =  ["true", true].include?(options[:calculate_on_background])
      number_of_workers_to_add = 0

      runner_by_region_operator_pivacy_and_standard_service(options) do |region_id, region_prefix, operator_id, privacy_id, standard_service_id|
        if background            
          number_of_workers_to_add += 1
          ::ScrapServiceGroup.perform_async(region_id, operator_id, privacy_id, standard_service_id, options)
        else
          run_scraper_for_region_operator_privacy_standard_service_group(region_id, operator_id, privacy_id, standard_service_id, options)
        end      
      end
      if background
        worker_name = 'scrap_service_group'
        base_worker_add_number = 3
        number_of_workers_to_add = [
          base_worker_add_number - ::Background::WorkerManager::Manager.worker_quantity(worker_name),
          number_of_workers_to_add
        ].min
        puts ["Background::WorkerManager::Manager.start_number_of_worker", worker_name, number_of_workers_to_add].to_s
        ::Background::WorkerManager::Manager.start_number_of_worker(worker_name, number_of_workers_to_add)
      end
    end
    
    def self.run_scraper_for_region_operator_privacy_standard_service_group(region_id, operator_id, privacy_id, standard_service_id, options)
      tarif_lists_for_parsing = TarifList.includes(:tarif_class).where(:tarif_classes => {:operator_id => operator_id, :standard_service_id => standard_service_id, :privacy_id => privacy_id}).
        where(:region_id => region_id).where("(tarif_classes.features->>'for_parsing')::boolean is true")
      
      tarif_lists_for_parsing.each do |tarif_list_for_parsing|
        force_to_scrap = options[:force_to_scrap] || options['force_to_scrap']
        scrap_tarif_list_for_parsing(tarif_list_for_parsing, options, [], force_to_scrap)
      end
    end

    def self.scrap_tarif_list_for_parsing(tarif_list_for_parsing, options = {}, chosen_services_to_scrap = [], force_to_scrap = false)      
      scraped_urls_for_tarif_list_for_parsing = {}
      current_scraped_services = {}
      
      services_to_scrap = (tarif_list_for_parsing.current_to_scrap_services || {}).dup
      services_to_scrap.slice!(*chosen_services_to_scrap) if !chosen_services_to_scrap.blank?
      services_to_scrap.each do |normalized_service_name, to_scrap_service_values|
        
        base_service_id = to_scrap_service_values.try(:[], 'all_exisitng_services_value').try(:[], 'ids').try(:[], 0).try(:to_i)
        base_service = TarifClass.where(:id => base_service_id).first
        next if base_service.blank?

        region_prefix = Category::Region::Desc.new(tarif_list_for_parsing.region_id, base_service.operator_id).subdomain

        tarif_list = TarifList.find_or_create_by(:tarif_class_id => base_service_id, :region_id => tarif_list_for_parsing.region_id)
        
        visited_page_url = tarif_list.features.try(:[], 'visited_page_url')
        to_visit_page_http = to_scrap_service_values.try(:[], 'services_to_scrap_value').try(:[], 'urls').try(:[], 0) || base_service.http
        to_visit_page_url = region_http_from_full_http(to_visit_page_http, region_prefix, base_service.operator_id, base_service.privacy_id)

        next if [true, 'true'].include?(tarif_list.tarif_class.for_parsing)

        condition_to_scrap = tarif_list.features.try(:[], 'initial_processing').try(:[], 'h1').blank? or
          visited_page_url != to_visit_page_url or 
          tarif_list.tarif_list_for_parsing_ids.blank? or 
          visited_page_url.blank?
        next if !condition_to_scrap and ![true, 'true'].include?(force_to_scrap)

        if scraped_urls_for_tarif_list_for_parsing[to_visit_page_url].blank?
          page_info = scrap_service(base_service.operator_id, tarif_list_for_parsing.region_id, base_service, options, to_visit_page_url)
          scraped_urls_for_tarif_list_for_parsing[to_visit_page_url] = page_info
        else
          page_info = scraped_urls_for_tarif_list_for_parsing[to_visit_page_url]
        end

        page_info ||= {}
        page_info[:features] ||= tarif_list.features || {}
        page_info[:features][:tarif_list_for_parsing_ids] ||= []
        page_info[:features][:tarif_list_for_parsing_ids] += ([tarif_list_for_parsing.id] - page_info[:features][:tarif_list_for_parsing_ids])
        tarif_list.update(page_info)
        if !page_info[:description].blank? and (page_info[:features][:status] || 1000) < 400
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
        current_scraped_services[normalized_service_name] = page_info[:features]

        sleep 1.0
      end
      
      tarif_list_for_parsing.prev_scraped_services = (tarif_list_for_parsing.prev_scraped_services || {}).merge(tarif_list_for_parsing.current_scraped_services || {})
      tarif_list_for_parsing.current_scraped_services = (tarif_list_for_parsing.current_scraped_services || {}).merge(current_scraped_services)
      tarif_list_for_parsing.save!
    end
    
    def self.runner_by_region_and_operator(options = {})
      Category::Region::Desc::Const.each do |region_id, desc_by_region_id|
        puts "start region_id #{region_id}"
        Category::Operator::Const::OperatorsWithParsing.each do |operator_id|
          puts "start operator_id #{operator_id}"
          region_prefix = Category::Region::Desc.new(region_id, operator_id).subdomain
          next if region_prefix.nil?
          yield [region_id, operator_id, region_prefix]
        end
      end
    end
    
    def self.runner_by_region_operator_pivacy_and_standard_service(options = {})
      region_ids = options['region_id'].blank? ? Category::Region::Desc::Const : options['region_id']
      operator_ids = options['operator_id'].blank? ? Category::Operator::Const::OperatorsWithParsing : options['operator_id']
      privacy_ids = options['privacy_id'].blank? ? [1, 2] : options['privacy_id']
      standard_service_ids = options['standard_service_id'].blank? ? TarifClass::ServiceType.values : options['standard_service_id']

      region_ids.each do |region_id, desc_by_region_id|
        puts "start region_id #{region_id}"
        operator_ids.each do |operator_id|
          puts "start operator_id #{operator_id}"
          region_prefix = Category::Region::Desc.new(region_id, operator_id).subdomain
          next if region_prefix.nil?
          privacy_ids.each do |privacy_id|
            standard_service_ids.each do |standard_service_id|
              yield [region_id, region_prefix, operator_id, privacy_id, standard_service_id]
            end
          end
        end
      end
    end
    
    def self.scrap_service(operator_id, region_id, service, options = {}, page_address_to_visit = nil, tarif_list_for_parsing_id = nil)
      scraper(options).scrape do |page|
        begin
          region_prefix = Category::Region::Desc.new(region_id, operator_id).subdomain
          next if service.http.blank?
          page_address = page_address_to_visit || region_http_from_full_http(service.http, region_prefix, operator_id, service.privacy_id)
          next if page_address.blank?
          
          initial_processing = {}
          initial_service_processing = {}

          puts "visiting page #{page_address}"
          page.visit(page_address) 
          puts "visited page #{page.current_url}"

          parser = ServiceParser::Runner.init({
            :operator_id => operator_id, 
            :region_id => region_id,
            :original_page => '',
            :tarif_class => service,
            :parsing_class => service.try(:parsing_class),
          })
          scraper.process_all_modals(page, parser.modal_tags)
          scraper.process_modal(page, parser.choose_region_tags)
          puts "checked for modals"

          if !parser.page_preview_action_tags.blank?
            scraper.process_page_preview_actions(page, parser.page_preview_action_tags)
            puts "processed page_preview_actions" 
          end

          page_info = {}
          
          parser.set_doc(page.html)
          
          initial_processing = parser.base_page_processing
          
          initial_service_processing = service.for_parsing == 'true' ? {} : parser.base_service_processing
          
          page_redirected_status_code = page.has_current_path?(page_address, :url => true, :wait => 0.01) ? nil : 301

          possible_page_load_status_code = scraper.options[:use_selenium] == 'true' ? page_redirected_status_code : (page_redirected_status_code || page.status_code)
          page_load_status_code = initial_processing[:error_404].blank? ? possible_page_load_status_code : 404          

          if !parser.page_special_action_steps.blank?
            page_place_for_special_action_result = Nokogiri::XML::Node.new('page_place_for_special_action_result', parser.doc)
            
            scraper.process_page_special_actions(page, parser.page_special_action_steps) do |keys, current_page, scope_to_save_tags, my_title|
              next if keys.blank? or keys == [nil]
              special_action_result = parser.check_and_return_first_node_with_scope(Nokogiri::HTML.fragment(current_page.html), scope_to_save_tags)
              
              if !special_action_result.blank?
                keys.each_with_index{|key, index| special_action_result["special_action_key_#{index}"] = key}
                if my_title and my_title.is_a?(Proc)
                  new_title = Nokogiri::XML::Node.new('my_title', parser.doc)
                  new_title.content = my_title.call(*keys)
                  special_action_result.add_child(new_title)
                end 
  
                page_place_for_special_action_result.add_child(special_action_result)     
              end
            end

            parser.body.add_child(page_place_for_special_action_result) if parser.body
            puts "processed page_special_actions" 
          end if true

          page_info.deep_merge!({
            :features => {
              :status => page_load_status_code,
              :visited_page_url => page_address,
              :initial_processing => initial_processing.merge(initial_service_processing),
              :updated => Time.now,
            },
            :description => parser.doc.to_html,
          })
        rescue Capybara::NotSupportedByDriverError
          puts "rescue Capybara::NotSupportedByDriverError"
          page_info = {
            :features => {
              :status => (page_load_status_code || -1),
              :visited_page_url => page_address,
              :initial_processing => initial_processing.merge(initial_service_processing),
              :updated => Time.now,
            },
            :description => parser.doc.to_html,
          }
        rescue Capybara::Poltergeist::TimeoutError
          puts "rescue Capybara::Poltergeist::TimeoutError"
          page_info = {
            :features => {
              :status => 408,
              :visited_page_url => page_address,
              :initial_processing => initial_processing.merge(initial_service_processing),
              :updated => Time.now,
            },
          }
        rescue Capybara::Poltergeist::StatusFailError
          puts "rescue Capybara::Poltergeist::StatusFailError"
        end
      end
    end
    
    def self.tarif_classes_for_parsing(region_id, operator_id, privacy_id = [], standard_service_id = [], force_to_scrap = false)
      result = TarifClass.for_parsing('true').where(:operator_id => operator_id)
      result = result.where(:privacy_id => privacy_id) if !privacy_id.blank?
      result = result.where(:standard_service_id => standard_service_id) if !standard_service_id.blank?
      result = result.where.not(:id => processed_service_ids_by_region(region_id, operator_id)) if !force_to_scrap
      result
    end
    
    def self.all_possible_active_service_ids(operator_id, privacy_id, standard_service_id)
      exisitng_service_names_to_skip_parsing = Scraper::SearchServices.
        exisitng_services_to_skip_parsing(operator_id, privacy_id, standard_service_id).try(:services_to_skip_scrap) || []
      
      Scraper::SearchServices.correct_uniq_tarif_classes_by_groups(operator_id, privacy_id, standard_service_id).
        map{|r| r.id if !exisitng_service_names_to_skip_parsing.include?(r.name)}.compact
    end
    
    def self.processed_service_ids_by_region(region_id, operator_id, maturity = 30)
      TarifList.joins(:tarif_class).where(:tarif_classes => {:operator_id => operator_id}).
        where(:region_id => region_id).where("tarif_lists.updated_at > :start_date", :start_date => maturity.day.ago).pluck(:tarif_class_id)
    end
    
    def self.region_http_from_full_http(full_http, region_prefix, operator_id, privacy_id)
      region_prefix_to_use = region_prefix.blank? ? '' : "#{region_prefix}."
      domain_to_use = domain(operator_id)
      service_address_to_use = full_http.split(domain_to_use)[1] || full_http.split(domain_to_use)[0]
      service_address_to_use = service_address_to_use[0] == '/' ? service_address_to_use : '/' + service_address_to_use
      service_address_to_use ? "http://#{privacy_prefix(operator_id, privacy_id)}#{region_prefix_to_use}#{domain_to_use}#{service_address_to_use}" : nil    
    end
    
    def self.privacy_prefix(operator_id, privacy_id)
      case 
      when [Category::Operator::Const::Tele2, Category::Operator::Const::Beeline, Category::Operator::Const::Megafon].include?(operator_id)
       ''
      when Category::Operator::Const::Mts == operator_id
        privacy_id == 1 ? 'corp.' : ''
      else
      end
    end

    def self.domain(operator_id)
      case operator_id
      when Category::Operator::Const::Tele2; 'tele2.ru';
      when Category::Operator::Const::Beeline;  'beeline.ru';
      when Category::Operator::Const::Megafon; 'megafon.ru';
      when Category::Operator::Const::Mts;  'mts.ru';
      else
      end
    end
    
  end

    
end