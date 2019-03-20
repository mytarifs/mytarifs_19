module Scraper 
  class SearchServices

    def self.update_saved_services_to_scrap_for_all_regions(options = {}, update_only_new = false)
      model = TarifList.joins(:tarif_class).where("(tarif_classes.features->>'for_parsing')::boolean is true")
      model = model.where(:tarif_classes => {:operator_id => options['operator_id']}) if !options['operator_id'].blank?
      model = model.where(:tarif_classes => {:privacy_id => options['privacy_id']}) if !options['privacy_id'].blank?
      model = model.where(:tarif_classes => {:standard_service_id => options['standard_service_id']}) if !options['standard_service_id'].blank?
      model.order("tarif_classes.operator_id, tarif_classes.privacy_id, tarif_classes.standard_service_id, region_id").each do |tarif_list_for_parsing|          
        update_saved_services_to_scrap_for_one_tarif_list_for_parsing(tarif_list_for_parsing, update_only_new)
      end
    end
    
    def self.update_saved_services_to_scrap_for_one_tarif_list_for_parsing(tarif_list_for_parsing, update_only_new = false)
      return nil if update_only_new and !tarif_list_for_parsing.current_to_scrap_services.blank?
      
      tc = tarif_list_for_parsing.tarif_class
      region_id = tarif_list_for_parsing.region_id
      
      search_result = {}
      services_to_exclude_from_search_result = []
      
      if ['true', true].include?(tarif_list_for_parsing.tarif_class.for_existing_servises)        
        search_unscrapped_services_from_services_hash(region_id, tc.operator_id, tc.privacy_id, tc.standard_service_id, nil, false).each do |result_key, result_value|
          raise(StandardError) if false  and result_key == "звонкизаграницу"
          if result_value[:to_scrap_status] == to_scrap_services_status_const["to_scrap"] and
            search_unscrapped_services_status_const.slice("to_find_services_to_scrap", "to_force_scraping").values.include?(result_value[:scrap_status])
            search_result[result_key] = result_value
            services_to_exclude_from_search_result -= [result_key]
          else
            services_to_exclude_from_search_result << result_key
          end
        end
      else
        search_unscrapped_services_from_services_hash(region_id, tc.operator_id, tc.privacy_id, tc.standard_service_id, tc.id, true).each do |result_key, result_value|
          if result_value[:to_scrap_status] == to_scrap_services_status_const["to_scrap"]
            search_result[result_key] = result_value 
            services_to_exclude_from_search_result -= [result_key]
          else
            services_to_exclude_from_search_result << result_key
          end
        end
      end

      tarif_list_for_parsing.prev_to_scrap_services = tarif_list_for_parsing.current_to_scrap_services.blank? ? search_result : tarif_list_for_parsing.current_to_scrap_services
      tarif_list_for_parsing.current_to_scrap_services = (tarif_list_for_parsing.current_to_scrap_services || {}).
        except(*services_to_exclude_from_search_result).merge(search_result)
      tarif_list_for_parsing.save!
    end
    
    def self.search_unscrapped_services_from_services_hash_for_all_regions(operator_id, privacy_id, standard_service_id, tarif_class_id_for_parsing = nil, source_for_search = nil)
      result = {}
      TarifList.joins(:tarif_class).where(:tarif_classes => {:operator_id => operator_id, :standard_service_id => standard_service_id, :privacy_id => privacy_id}).
        where("(tarif_classes.features->>'for_parsing')::boolean is true").pluck("region_id").uniq.each do |region_id|
          result_for_region = case source_for_search
          when 'current_to_scrap_services', 'prev_to_scrap_services'
            saved_to_scrap_services_by_region(region_id, operator_id, privacy_id, standard_service_id, tarif_class_id_for_parsing, source_for_search)
          else 
            search_unscrapped_services_from_services_hash(region_id, operator_id, privacy_id, standard_service_id, tarif_class_id_for_parsing, true);
          end
          
          result_for_region.each do |result_key, result_value|
            scrap_status = result_value[:scrap_status] > search_unscrapped_services_status_const["executed"] ? search_unscrapped_services_status_const["executed"] : result_for_region[result_key][:scrap_status]
            result_value[:scrap_status] = [scrap_status, result[result_key].try(:[], :scrap_status)].compact.max

            result_value[:to_scrap_status] = [result_value[:to_scrap_status], result[result_key].try(:[], :to_scrap_status)].compact.min 
            result_value[:services_to_scrap] = (result_value[:services_to_scrap] or result[result_key].try(:[], :services_to_scrap)) 
            result_value[:scrapped_services] = (result_value[:scrapped_services] or result[result_key].try(:[], :scrapped_services))
            
            result_value[:services_to_scrap_value] = result[result_key].try(:[], :services_to_scrap_value) if result_value[:services_to_scrap_value].blank?
            result_value[:all_exisitng_services_value] = result[result_key].try(:[], :all_exisitng_services_value) if result_value[:all_exisitng_services_value].blank?

            result[result_key] ||= {}
            
            result[result_key][:services_to_scrap_urls] ||= []
            result[result_key][:services_to_scrap_urls] += (result_value[:services_to_scrap_urls] - result[result_key][:services_to_scrap_urls])

            result[result_key][:buttons] ||= []
            buttons_to_merge = result_for_region[result_key][:buttons].select do |button_key|
              unscrapped_service_management_buttons(result_value[:services_to_scrap_value], result_value[:all_exisitng_services_value])[button_key].
                try(:[], :button_params)
            end
            result_value[:buttons] = (buttons_to_merge + result[result_key][:buttons]).compact.uniq
          end if !result.blank?
          result.deep_merge!(result_for_region)
      end
      result
    end
    
    def self.saved_to_scrap_services_by_region(region_id, operator_id, privacy_id, standard_service_id, tarif_class_id_for_parsing, source_for_search)
      result = {}

      tarif_lists_for_parsing = TarifList.joins(:tarif_class).
        where(:tarif_classes => {:operator_id => operator_id, :standard_service_id => standard_service_id, :privacy_id => privacy_id}).
        where(:region_id => region_id).
        where("(tarif_classes.features->>'for_parsing')::boolean is true")
      tarif_lists_for_parsing = tarif_lists_for_parsing.where(:tarif_class_id => tarif_class_id_for_parsing) if tarif_class_id_for_parsing

      tarif_lists_for_parsing.each do |tl_for_parsing|
        saved_result = tl_for_parsing.send(source_for_search.to_sym) || {}
        puts
        puts "saved_result #{tl_for_parsing.attributes['features']['prev_to_scrap_services'].keys}"
        puts "saved_result #{saved_result}"
        puts
        saved_result.keys.each do |key|
          saved_result[key].deep_symbolize_keys!
          saved_result[key][:buttons] = saved_result[key][:buttons].map(&:to_sym) 
        end
        result.merge!(saved_result)
      end
      result
    end
    
    def self.search_unscrapped_services_from_services_hash(region_id, operator_id, privacy_id, standard_service_id, tarif_class_id_for_parsing, include_only_services_from_scrap = false)
      tarif_lists_for_parsing = TarifList.includes(:tarif_class).
        where(:tarif_classes => {:operator_id => operator_id, :standard_service_id => standard_service_id, :privacy_id => privacy_id}).
        where(:region_id => region_id).
        where("(tarif_classes.features->>'for_parsing')::boolean is true")
      tarif_lists_for_parsing = tarif_lists_for_parsing.where(:tarif_class_id => tarif_class_id_for_parsing) if tarif_class_id_for_parsing
      
      services_to_scrap_by_name = services_to_scrap_by_name(region_id, operator_id, privacy_id, standard_service_id, tarif_lists_for_parsing)
      services_to_skip_scrap_by_name = services_to_skip_scrap_by_name(region_id, operator_id, privacy_id, standard_service_id, tarif_lists_for_parsing)
      all_exisitng_services_by_name = all_exisitng_services_by_name(operator_id, privacy_id, standard_service_id)
      all_services_for_parsing_by_name = all_services_for_parsing_by_name(operator_id, privacy_id, standard_service_id)
      scrapped_services_by_name = scrapped_services_by_name(region_id, operator_id, privacy_id, standard_service_id)
      
      result = {}
      result_keys = if include_only_services_from_scrap
        (services_to_scrap_by_name.keys + services_to_skip_scrap_by_name.keys).uniq
      else
        (services_to_scrap_by_name.keys + services_to_skip_scrap_by_name.keys + all_services_for_parsing_by_name.keys +
          all_exisitng_services_by_name.keys + scrapped_services_by_name.keys).uniq
      end
      result_keys.each do |service_name|

        original_name = (services_to_scrap_by_name[service_name].try(:[], :original_name) || all_exisitng_services_by_name[service_name].try(:[], :original_name) ||
          scrapped_services_by_name[service_name].try(:[], :original_name)) || all_services_for_parsing_by_name[service_name].try(:[], :original_name)
          
        tarif_class_exist = (all_exisitng_services_by_name[service_name].blank? ? false : true)
        exisitng_services_to_skip_parsing = all_exisitng_services_by_name[service_name].try(:[], :exisitng_service_to_skip_parsing) || false
        exisitng_services_to_force_scraping = all_exisitng_services_by_name[service_name].try(:[], :exisitng_services_to_force_scraping) || false
        tarif_class_for_parsing_exist = (all_services_for_parsing_by_name[service_name].blank? ? false : true)
        archived_status = (all_exisitng_services_by_name[service_name].try(:[], :archived_status) || [false])
        services_to_scrap = (services_to_scrap_by_name[service_name].blank? ? false : true)
        services_to_skip_scrap = (services_to_skip_scrap_by_name[service_name].blank? ? false : true)
        scrapped_services = (scrapped_services_by_name[service_name].blank? ? false : true)
        load_status = scrapped_services_by_name[service_name].try(:[], :load_statuses)

        to_scrap_status = case
        when services_to_scrap_by_name[service_name].try(:[], :urls).try(:uniq) == [nil]; to_scrap_services_status_const["unknown"]
        when ([exisitng_services_to_skip_parsing] == [true]); to_scrap_services_status_const["existing_services_to_skip_scrap"];
        when ([tarif_class_for_parsing_exist] == [true]); to_scrap_services_status_const["used_for_parsing"];
        when ([services_to_skip_scrap] == [true]); to_scrap_services_status_const["services_to_skip_scrap"];
        else to_scrap_services_status_const["to_scrap"]
        end
        
        scrap_status = case
        when ([tarif_class_exist, tarif_class_for_parsing_exist, exisitng_services_to_force_scraping] == [true, false, true]); search_unscrapped_services_status_const["to_force_scraping"];
        when ([tarif_class_exist, services_to_scrap, scrapped_services] == [true, true, true]); search_unscrapped_services_status_const["executed"];
        when ([tarif_class_exist, services_to_scrap, scrapped_services, load_status] == [true, false, true, ['404']]); search_unscrapped_services_status_const["no_such_page"];
        when ([services_to_scrap, archived_status] == [false, [true]]); search_unscrapped_services_status_const["archived"];
        when ([services_to_scrap, scrapped_services, load_status] == [false, true, ['200']]); search_unscrapped_services_status_const["to_find_services_to_scrap"];
        when ([services_to_scrap, scrapped_services, load_status] == [false, true, ['301']]); search_unscrapped_services_status_const["to_find_services_to_scrap"];
        when ([tarif_class_exist, tarif_class_for_parsing_exist, services_to_scrap] == [false, false, true]); search_unscrapped_services_status_const["to_add_tarif_class"];
        when ([tarif_class_exist, services_to_scrap, load_status] == [true, true, nil]); search_unscrapped_services_status_const["to_scrap_service"];
        else search_unscrapped_services_status_const["unknown"]
        end
        
        buttons = []
        buttons << :add_tarif_class_for_parsing if services_to_scrap and !tarif_class_for_parsing_exist and !tarif_class_exist
        buttons << :add_new_service if !tarif_class_exist and !tarif_class_for_parsing_exist and services_to_scrap
        buttons << :add_exisitng_service_to_skip_parsing if tarif_class_exist and !exisitng_services_to_skip_parsing
        buttons << :cancel_exisitng_service_to_skip_parsing if tarif_class_exist and exisitng_services_to_skip_parsing
        buttons << :force_exisitng_service_to_scrap if tarif_class_exist and !exisitng_services_to_force_scraping and scrap_status == search_unscrapped_services_status_const["unknown"]
        buttons << :cancel_force_exisitng_service_to_scrap if tarif_class_exist and exisitng_services_to_force_scraping
        buttons << :skip_service_to_scrap if !tarif_class_for_parsing_exist and services_to_scrap_by_name[service_name].try(:[], :base_tarif_classes).try(:[], 0) and 
          services_to_scrap and !services_to_skip_scrap
        buttons << :cancel_skip_service_to_scrap if !tarif_class_for_parsing_exist and services_to_scrap_by_name[service_name].try(:[], :base_tarif_classes).try(:[], 0) and 
          services_to_skip_scrap

        result[service_name] = {
          :original_name => original_name, 
          :scrap_status => scrap_status,
          :to_scrap_status => to_scrap_status,
          :tarif_class_exist => tarif_class_exist,
          :exisitng_services_to_skip_parsing => exisitng_services_to_skip_parsing,
          :exisitng_services_to_force_scraping => exisitng_services_to_force_scraping,
          :tarif_class_for_parsing_exist => tarif_class_for_parsing_exist,
          :services_to_scrap => services_to_scrap,
          :scrapped_services => scrapped_services,
          :archived_status => archived_status,
          :load_status => load_status,
          :all_exisitng_services_value => all_exisitng_services_by_name[service_name],
          :tarif_class_url => (all_exisitng_services_by_name[service_name].try(:[], :urls) || []),
          :services_to_scrap_value => services_to_scrap_by_name[service_name],
          :services_to_scrap_urls => (services_to_scrap_by_name[service_name].try(:[], :urls) || []),
          :services_to_scrap_base_tarif_classes => (services_to_scrap_by_name[service_name].try(:[], :base_tarif_classes) || []),
          :skip_scrap_services_url => services_to_skip_scrap_by_name[service_name].try(:[], :urls),
          :scrapped_services_url => scrapped_services_by_name[service_name].try(:[], :urls),
          :links_are_equal => ( (all_exisitng_services_by_name[service_name].try(:[], :urls) || []) == (services_to_scrap_by_name[service_name].try(:[], :urls) || []) ),
          :buttons => buttons
        }
        raise(StandardError, [
          result[service_name][:all_exisitng_services_value]
        ]) if false and original_name == "Маяк"

      end
      result 
    end

    def self.services_to_scrap_by_name(region_id, operator_id, privacy_id, standard_service_id, tarif_lists_for_parsing)
      result = {}
      tarif_lists_for_parsing.each do |tarif_list|
        next if tarif_list.tarif_class.blank?
        
        parser = ServiceParser::Runner.init({
          :operator_id => operator_id, 
          :region_id => tarif_list.try(:region_id), 
          :original_page => tarif_list.description, 
          :tarif_class => tarif_list.try(:tarif_class), 
          :parsing_class => tarif_list.try(:tarif_class).try(:parsing_class)})
  
        services_to_scrap_by_name = parser.search_services(tarif_list.tarif_class.search_services_tag, parser.excluded_words_for_service_search, tarif_list.visited_page_url)
        
        services_to_scrap_by_name.each do |service_name_1, urls|
        raise(StandardError, [
          services_to_scrap_by_name
        ]) if false
          urls_without_domen = urls.map{|url| parser.url_without_domain(url) }
          service_name = parser.normailze_name(service_name_1)
          result[service_name] ||= {:urls => [], :base_tarif_classes => []}
          result[service_name][:original_name] = service_name_1
          result[service_name][:urls] += (urls_without_domen - result[service_name][:urls])
          result[service_name][:base_tarif_classes] += ([tarif_list.tarif_class.try(:id)].compact - result[service_name][:base_tarif_classes])
        end
      end      
      result
    end
    
    def self.services_to_skip_scrap_by_name(region_id, operator_id, privacy_id, standard_service_id, tarif_lists_for_parsing)
      result = {}
      tarif_lists_for_parsing.each do |tarif_list|
        next if tarif_list.tarif_class.blank?
        
        parser = ServiceParser::Runner.init({
          :operator_id => operator_id, 
          :region_id => tarif_list.try(:region_id),
          :original_page => tarif_list.description,
          :tarif_class => tarif_list.try(:tarif_class), 
          :parsing_class => tarif_list.try(:tarif_class).try(:parsing_class)})
        
        url_without_domen = parser.url_without_domain(tarif_list.tarif_class.try(:http))
        
        (tarif_list.tarif_class.services_to_skip_scrap || []).each do |service_name_1|
          service_name = parser.normailze_name(service_name_1)
          
          result[service_name] ||= {:urls => [], :base_tarif_classes => []}
          result[service_name][:original_name] = service_name_1
          result[service_name][:urls] += ([url_without_domen] - result[service_name][:urls])
          result[service_name][:base_tarif_classes] += ([tarif_list.tarif_class.try(:id)].compact - result[service_name][:base_tarif_classes])
        end
      end      
      result
    end
    
    def self.all_exisitng_services_by_name(operator_id, privacy_id, standard_service_id)
      result = {}
      parser = ServiceParser::Runner.init({:operator_id => operator_id, :original_page => ''})

      tarif_class_for_exisitng_services_to_skip_parsing = exisitng_services_to_skip_parsing(operator_id, privacy_id, standard_service_id)
      exisitng_services_to_skip_parsing = tarif_class_for_exisitng_services_to_skip_parsing.try(:services_to_skip_scrap) || []
      exisitng_services_to_force_scraping = tarif_class_for_exisitng_services_to_skip_parsing.try(:services_to_force_scrap) || []
      
      correct_uniq_tarif_classes_by_groups(operator_id, privacy_id, standard_service_id).each do |tarif_class|
        next if tarif_class.http.blank?
        url_without_domen = parser.url_without_domain(tarif_class.http)
        tarif_class_name = parser.normailze_name(tarif_class.name)
        archived_status = [true, 'true'].include?(tarif_class.is_archived) ? true : false
        result[tarif_class_name] ||= {:urls => [], :archived_status => [], :ids => [], :original_name => tarif_class.name}
        result[tarif_class_name][:urls] += ([url_without_domen] - result[tarif_class_name][:urls])
        result[tarif_class_name][:archived_status] += ([archived_status] - result[tarif_class_name][:archived_status])
        result[tarif_class_name][:ids] += ([tarif_class.id] - result[tarif_class_name][:ids])
        result[tarif_class_name][:ids].sort!
        result[tarif_class_name][:tarif_class_id_for_exisitng_services_to_skip_parsing] = tarif_class_for_exisitng_services_to_skip_parsing.try(:id)
        result[tarif_class_name][:exisitng_service_to_skip_parsing] = exisitng_services_to_skip_parsing.include?(tarif_class.name) ? true : false
        result[tarif_class_name][:exisitng_services_to_force_scraping] = exisitng_services_to_force_scraping.include?(tarif_class.name) ? true : false
      end
      result
    end
    
    def self.all_services_for_parsing_by_name(operator_id, privacy_id, standard_service_id)
      result = {}
      parser = ServiceParser::Runner.init({:operator_id => operator_id, :original_page => ''})
      
      base_tarif_classes_by_groups_for_parsing(operator_id, privacy_id, standard_service_id).each do |tarif_class|
        next if tarif_class.http.blank?
        url_without_domen = parser.url_without_domain(tarif_class.http)
        tarif_class_name = parser.normailze_name(tarif_class.name)# + "___" + url_without_domen
        archived_status = [true, 'true'].include?(tarif_class.is_archived) ? true : false
        result[tarif_class_name] ||= {:urls => [], :archived_status => [], :ids => [], :original_name => tarif_class.name}
        result[tarif_class_name][:urls] += ([url_without_domen] - result[tarif_class_name][:urls])
        result[tarif_class_name][:archived_status] += ([archived_status] - result[tarif_class_name][:archived_status])
        result[tarif_class_name][:ids] += ([tarif_class.id] - result[tarif_class_name][:ids])
        result[tarif_class_name][:ids].sort!
      end
      result
    end
    
    def self.exisitng_services_to_skip_parsing(operator_id, privacy_id, standard_service_id)
      base_tarif_classes_by_groups_for_parsing(operator_id, privacy_id, standard_service_id).
        where("(features->>'for_existing_servises')::boolean is true").first
    end
    
    def self.scrapped_services_by_name(region_id, operator_id, privacy_id, standard_service_id)
      result = {}
      parser = ServiceParser::Runner.init({:operator_id => operator_id, :original_page => ''})
      TarifList.joins(:tarif_class).where(:tarif_class_id => base_tarif_classes_by_groups_not_for_parsing(operator_id, privacy_id, standard_service_id).pluck(:id).uniq).
        where(:region_id => region_id).
        select("array_agg(tarif_lists.id) as tarif_list_ids, array_agg(tarif_lists.tarif_class_id) as tarif_class_ids, \
          array_agg(tarif_lists.features->>'visited_page_url') as visited_page_urls, \
          array_agg(tarif_lists.features->>'status') as load_statuses, \
          tarif_classes.name as tarif_class_name").
        group("tarif_classes.name").each do |item|
          name = parser.normailze_name(item.tarif_class_name)
          result[name] ||= {}
          result[name] = {
            :original_name => item.tarif_class_name,
            :urls => item.visited_page_urls.map{|url| parser.url_without_domain(url)}, 
            :tarif_list_ids => item.tarif_list_ids,
            :tarif_class_ids => item.tarif_class_ids,
            :load_statuses => item.load_statuses,
          }
      end
      result
    end
    
    def self.search_unscrapped_services_status
      {
        90 => "executed",
        94 => "no such_page",
        95 => "archived",
        8 => "to find services to_scrap",
        7 => "to add tarif class",
        6 => "to scrap service",
        5 => "to_force_scraping",
        0 => "unknown"
      }
    end
    
    def self.search_unscrapped_services_status_const
      {
        "executed" => 90,
        "no_such_page" => 94,
        "archived" => 95,
        "to_find_services_to_scrap" => 8,
        "to_add_tarif_class" => 7,
        "to_scrap_service" => 6,
        "to_force_scraping" => 5,
        "unknown" => 0,
      }
    end
    
    def self.to_scrap_services_status
      {
        91 => "existing services to skip scrap",
        92 => "used_for parsing",
        93 => "services to skip scrap",
        1 => "unknown",
        0 => "to scrap",
      }
    end
    
    def self.to_scrap_services_status_const
      {
        "existing_services_to_skip_scrap" => 91,
        "used_for_parsing" => 92,
        "services_to_skip_scrap" => 93,
        "unknown" => 1,
        "to_scrap" => 0,
      }
    end
    
    def self.unscrapped_service_management_buttons(service_to_scrap_by_name = nil, all_exisitng_services_value = nil)
      result = {
        :add_tarif_class_for_parsing => {:name => "add_tc for parsing"}, :add_new_service => {:name => "add new service"}, 
        :skip_service_to_scrap => {:name => "skip service to scrap"}, :cancel_skip_service_to_scrap => {:name => "cancel skip service to scrap"},
        :add_exisitng_service_to_skip_parsing => {:name => "add exisitng service to skip parsing"}, 
        :cancel_exisitng_service_to_skip_parsing => {:name => "cancel exisitng service to skip parsing"}, 
        :force_exisitng_service_to_scrap => {:name => "force exisitng service to scrap"}, 
        :cancel_force_exisitng_service_to_scrap => {:name => "cancel force exisitng service to scrap"}, 
      }

      result.merge!({
        :add_tarif_class_for_parsing => {:name => "add_tc for parsing", :button_params => {'process_service_list_parsing' => {
                :command => 'add_tarif_class_for_parsing', :params => {
                  :new_tarif_class_name => service_to_scrap_by_name[:original_name],
                  :existing_tarif_class_id => service_to_scrap_by_name.try(:[], :base_tarif_classes).try(:[], 0),
                  :url => service_to_scrap_by_name.try(:[], :urls).try(:[], 0),
        } } } },
        :add_new_service => {:name => "add new service", :button_params => {'process_service_list_parsing' => {
                :command => 'add_new_service', :params => {
                  :new_tarif_class_name => service_to_scrap_by_name[:original_name],
                  :existing_tarif_class_id => service_to_scrap_by_name.try(:[], :base_tarif_classes).try(:[], 0),
                  :url => service_to_scrap_by_name.try(:[], :urls).try(:[], 0),
        } } } },
        :skip_service_to_scrap => {:name => "skip service to scrap", :button_params => {'process_service_list_parsing' => {
                :command => 'skip_service_to_scrap', :params => {
                  :existing_tarif_class_id => service_to_scrap_by_name[:base_tarif_classes][0],
                  :skip_service_name => service_to_scrap_by_name[:original_name],
        } } } },
        :cancel_skip_service_to_scrap => {:name => "cancel skip service to scrap", :button_params => {'process_service_list_parsing' => {
                :command => 'cancel_skip_service_to_scrap', :params => {
                  :existing_tarif_class_id => service_to_scrap_by_name[:base_tarif_classes][0],
                  :skip_service_name => service_to_scrap_by_name[:original_name],
        } } } },
      }) if service_to_scrap_by_name

      result.merge!({
        :add_exisitng_service_to_skip_parsing => {:name => "add exisitng service to skip parsing", :button_params => {'process_service_list_parsing' => {
                :command => 'add_exisitng_service_to_skip_parsing', :params => {
                  :skip_service_name => all_exisitng_services_value[:original_name],
                  :existing_tarif_class_id => all_exisitng_services_value.try(:[], :tarif_class_id_for_exisitng_services_to_skip_parsing),
        } } } },
        :cancel_exisitng_service_to_skip_parsing => {:name => "cancel exisitng service to skip parsing", :button_params => {'process_service_list_parsing' => {
                :command => 'cancel_exisitng_service_to_skip_parsing', :params => {
                  :skip_service_name => all_exisitng_services_value[:original_name],
                  :existing_tarif_class_id => all_exisitng_services_value.try(:[], :tarif_class_id_for_exisitng_services_to_skip_parsing),
        } } } },
        :force_exisitng_service_to_scrap => {:name => "force exisitng service to scrap", :button_params => {'process_service_list_parsing' => {
                :command => 'force_exisitng_service_to_scrap', :params => {
                  :to_force_service_name => all_exisitng_services_value[:original_name],
                  :existing_tarif_class_id => all_exisitng_services_value.try(:[], :tarif_class_id_for_exisitng_services_to_skip_parsing),
        } } } },
        :cancel_force_exisitng_service_to_scrap => {:name => "cancel force exisitng service to scrap", :button_params => {'process_service_list_parsing' => {
                :command => 'cancel_force_exisitng_service_to_scrap', :params => {
                  :to_force_service_name => all_exisitng_services_value[:original_name],
                  :existing_tarif_class_id => all_exisitng_services_value.try(:[], :tarif_class_id_for_exisitng_services_to_skip_parsing),
        } } } },
      }) if all_exisitng_services_value
      
      result
    end
    
    #Scraper::SearchServices.mark_secondary_tarif_class
    def self.mark_secondary_tarif_class
      iterate_on_tarif_classes_groups do |operator_id, privacy_id, standard_service_id|
        base_sql = base_tarif_classes_by_groups_not_for_parsing(operator_id, privacy_id, standard_service_id).to_sql
        secondary_tarif_classes_sql = "with base_tarif_classes as (#{base_sql}) select id, name, features, features->>'region_txt' as region_txt from base_tarif_classes as tc_1 where name in ( select name from base_tarif_classes as tc_2 where tc_2.id < tc_1.id)"
        TarifClass.find_by_sql(secondary_tarif_classes_sql).each do |tarif_class|
          puts [operator_id, privacy_id, standard_service_id, tarif_class.name, tarif_class.region_txt].to_s
          tc_to_update = TarifClass.where(:id => tarif_class.id).first
          if tc_to_update
            tc_to_update.secondary_tarif_class = 'true'
            tc_to_update.save!
          end
        end
      end
    end
    
    #Scraper::SearchServices.correct_uniq_tarif_classes_by_groups(1030, 2, 40)
    def self.correct_uniq_tarif_classes_by_groups(operator_id, privacy_id, standard_service_id)
      base_sql = base_tarif_classes_by_groups_not_for_parsing(operator_id, privacy_id, standard_service_id).to_sql
      sql = "with base_tarif_classes as (#{base_sql}) select * from base_tarif_classes as tc_1 where name not in ( select name from base_tarif_classes as tc_2 where tc_2.id < tc_1.id)"
      TarifClass.find_by_sql(sql)
    end
    
    #Scraper::SearchServices.wrong_tarif_lists_by_groups(1030, 2, 40)
    def self.wrong_tarif_lists_by_groups(operator_id, privacy_id, standard_service_id)
      base_sql = base_tarif_classes_by_groups_not_for_parsing(operator_id, privacy_id, standard_service_id).to_sql
      wrong_tarif_classes_sql = "with base_tarif_classes as (#{base_sql}) select id from base_tarif_classes as tc_1 where name in ( select name from base_tarif_classes as tc_2 where tc_2.id < tc_1.id)"
      TarifList.where("tarif_class_id in ( #{wrong_tarif_classes_sql} )")
    end

    def self.base_tarif_classes_by_groups_not_for_parsing(operator_id, privacy_id, standard_service_id)
      TarifClass.where(:operator_id => operator_id, :privacy_id => privacy_id, :standard_service_id => standard_service_id).
        where.not("(features->>'for_parsing')::boolean is true")
    end
    
    def self.base_tarif_classes_by_groups_for_parsing(operator_id, privacy_id, standard_service_id)
      TarifClass.where(:operator_id => operator_id, :privacy_id => privacy_id, :standard_service_id => standard_service_id).
        where("(features->>'for_parsing')::boolean is true")
    end
    
    #Scraper::SearchServices.clean_wrong_tarif_lists
    def self.clean_wrong_tarif_lists
      iterate_on_tarif_classes_groups do |operator_id, privacy_id, standard_service_id|
        wrong_tarif_lists_by_groups(operator_id, privacy_id, standard_service_id).delete_all
      end
    end
    
    def self.iterate_on_tarif_classes_groups
      Category::Operator::Const::OperatorsWithTarifs.each do |operator_id|
        [1, 2].each do |privacy_id|
          TarifClass::ServiceType.values.each do |standard_service_id|
            yield [operator_id, privacy_id, standard_service_id]
          end
        end        
      end
    end
  
  end

    
end