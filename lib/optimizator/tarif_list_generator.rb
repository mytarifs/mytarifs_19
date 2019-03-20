#TODO рассмотреть возможность добавить исключение опций из оптимизации по cost factor (цена на единицу объема выше определенного порога)
module Optimizator
  class TarifListGenerator  
    attr_reader :options, :calculate_only_chosen_services, :m_region, :m_region_id 
    attr_accessor :fobidden_combinations_by_service, :allowed_common_services                
    
    Parts = [
      'all-world-rouming/sms'.freeze, 'all-world-rouming/mms'.freeze, 'all-world-rouming/calls'.freeze, 'all-world-rouming/mobile-connection'.freeze,
      'own-country-rouming/sms'.freeze, 'own-country-rouming/mms'.freeze, 'own-country-rouming/calls'.freeze, 'own-country-rouming/mobile-connection'.freeze, 
      'onetime'.freeze, 'periodic'.freeze, #'mms'.freeze, 
    ]

    def initialize(options = {} )
      @options = options
      @m_region = options[:user_input][:region_txt]
      @m_region_id = Category::MobileRegions[@m_region].try(:[], 'region_ids'). try(:[], 0)
      raise(StandardError, [@privacy_id, @m_region_id, @m_region, options[:user_input] ].to_s) if false
      @calculate_only_chosen_services = options[:tarif_list_generator_params].slice(:calculate_only_chosen_services, :calculate_with_fixed_services).include?("true") ? true : false
    end
    
    #Optimizator::TarifListGenerator.test
    def self.test(calculate_all_tarifs = false)
      privacy_id = 2; region_txt = 'rostov_i_oblast'
      operators = [1030]
      tarifs = calculate_all_tarifs ? Customer::Info::ServiceChoices.tarifs(privacy_id, region_txt) : {1030 => [201]}
      options = {
        :services_by_operator => {
          :operators => operators,
          :tarifs => tarifs,
          :common_services => Customer::Info::ServiceChoices.common_services(privacy_id, region_txt),
          :tarif_options => Customer::Info::ServiceChoices.tarif_options(privacy_id, region_txt),
        },
        :tarif_list_generator_params => {
          :calculate_with_multiple_use => "true"
        },
        :user_input => {
          :region_txt => region_txt,
        }, 
      }
      tarif_list_generator = Optimizator::TarifListGenerator.new(options)
      tarif_list_generator#.tarif_pathes
    end
    
    def parts
      return @parts if @parts
      @parts = TarifListGenerator::Parts & ((options[:parts_to_use] || TarifListGenerator::Parts) + ['onetime'.freeze, 'periodic'.freeze])
    end

    def operator
      return @operator if @operator
      if options[:services_by_operator][:operators].blank? 
        1023
      else
        options[:services_by_operator][:operators][0]
      end
    end
    
    def tarifs
      @tarifs ||= options.try(:[], :services_by_operator).try(:[], :tarifs).try(:[], operator) || [200]
    end
    
    def common_services
      @common_services ||= options.try(:[], :services_by_operator).try(:[], :common_services).try(:[], operator) || []
    end

    def tarif_options
      @tarif_options ||= options.try(:[], :services_by_operator).try(:[], :tarif_options).try(:[], operator) || []
    end

    def all_services
      @all_services ||= tarifs + tarif_options + common_services
    end
    
    def dependencies
      return @dependencies if  @dependencies
      @dependencies = {}
      TarifClass.where(:id => all_services).select("*".freeze).all.each do |r|
        raise(StandardError, "tarif_class for parsing is used in calculations") if false and r.for_parsing == 'true'
        raise(StandardError, "secondary tarif_class is used in calculations") if false and r.features.try(:[], 'secondary_tarif_class') == 'true'
        @dependencies[r['id'.freeze]] = r['dependency'.freeze]
      end    
      @dependencies
    end
    
    def services_that_depended_on
      return @services_that_depended_on if @services_that_depended_on
      @services_that_depended_on = {}
      Service::CategoryTarifClass.where(:tarif_class_id => all_services).
        joins(as_standard_category_group: [:tarif_class, price_lists: :formulas]).
        where("#{TarifClass.regions_sql(m_region_id)}").
        where("#{Service::CategoryTarifClass.regions_sql(m_region_id)}").
        where("#{Price::Formula.regions_sql(m_region_id)}").
        where("(((service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::jsonb is not null) or 
          ((service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::text != '[]'))").
        select("service_category_groups.tarif_class_id, (service_category_tarif_classes.conditions->>'tarif_set_must_include_tarif_options')::jsonb as tarif_set_must_include_tarif_options").uniq.each do |r|
#          dependent_services = eval(r['tarif_set_must_include_tarif_options'])
          dependent_services = (r['tarif_set_must_include_tarif_options']).map(&:to_i)
          tarif_class_id = r['tarif_class_id'.freeze].to_i
          @services_that_depended_on[tarif_class_id] ||= []
          @services_that_depended_on[tarif_class_id] += ((dependent_services & all_services) - @services_that_depended_on[tarif_class_id])
      end    
      @services_that_depended_on
    end
    
    def periodic_services
      return @periodic_services if @periodic_services
      @periodic_services = []
      Service::CategoryTarifClass.
        joins(as_standard_category_group: [:tarif_class, price_lists: :formulas]).
        where("#{TarifClass.regions_sql(m_region_id)}").
        where("#{Service::CategoryTarifClass.regions_sql(m_region_id)}").
        where("#{Price::Formula.regions_sql(m_region_id)}").
        where(:tarif_class_id => all_services).where.not(:service_category_periodic_id => nil).select(:tarif_class_id).uniq.each do |r|
          tarif_class_id = r['tarif_class_id'.freeze].to_i
          @periodic_services << tarif_class_id
      end    
      @periodic_services
    end
    
    def onetime_services
      return @onetime_services if @onetime_services
      @onetime_services = []
      Service::CategoryTarifClass.
        joins(as_standard_category_group: [:tarif_class, price_lists: :formulas]).
        where("#{TarifClass.regions_sql(m_region_id)}").
        where("#{Service::CategoryTarifClass.regions_sql(m_region_id)}").
        where("#{Price::Formula.regions_sql(m_region_id)}").
        where(:tarif_class_id => all_services).where.not(:service_category_one_time_id => nil).select(:tarif_class_id).uniq.each do |r|
          tarif_class_id = r['tarif_class_id'.freeze].to_i
          @onetime_services << tarif_class_id
      end    
      @onetime_services
    end
    
    def uniq_parts
      return @uniq_parts if @uniq_parts
      @uniq_parts = []
      all_services.each do |service|
        @uniq_parts += ((dependencies[service] || {'parts' => []})['parts'.freeze] & parts) - @uniq_parts 
      end
      @uniq_parts
    end
    
    def common_services_by_parts
      return @common_services_by_parts if @common_services_by_parts
      @common_services_by_parts = {}
      common_services.each do |service|
        (dependencies[service]['parts'.freeze] & parts).each do |part|
          @common_services_by_parts[part] ||= []
          @common_services_by_parts[part] << service
        end
      end      
      @common_services_by_parts
    end
    
    def support_services
      return @support_services if @support_services
      @support_services = {}
      query_1 = TarifClass.
        select("tarif_classes.id as tarif_class_id, count(service_category_groups.id) as service_category_group_count, 
          jsonb_array_elements((tarif_classes.dependency->'parts')::jsonb) as part").
        joins("left join service_category_groups on service_category_groups.tarif_class_id = tarif_classes.id").
        where(:tarif_classes => {:id => all_services}).
        group("part, tarif_classes.id").
        having("count(service_category_groups.id) = 0")
      
      TarifClass.find_by_sql("with query_1 as (#{query_1.to_sql}) select array_agg(tarif_class_id) as tarif_class_ids, part from query_1 group by part").map do |row| 
        @support_services[row.part] ||= row.tarif_class_ids
      end
      @support_services
    end
    
    def used_support_services
      return @used_support_services if @used_support_services
      @used_support_services = {}
      query = Service::CategoryGroup.select(" array_agg(distinct service_category_groups.tarif_class_id) as tarif_class_ids,
              jsonb_array_elements((service_category_tarif_classes.conditions->'parts')::jsonb) as part,
              jsonb_array_elements((service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options')::jsonb) as support_service_id").
        joins(:service_category_tarif_classes, :tarif_class, price_lists: :formulas).
        where("#{TarifClass.regions_sql(m_region_id)}").
        where("#{Service::CategoryTarifClass.regions_sql(m_region_id)}").
        where("#{Price::Formula.regions_sql(m_region_id)}").
        where("json_array_length(service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options') > 0").
        where(:tarif_class_id => all_services).
        group("part, support_service_id").map do |row| 
          @used_support_services[row.part] ||= {}
          @used_support_services[row.part][row.support_service_id] = row.tarif_class_ids
      end
      @used_support_services
    end
    
    def service_packs
      return @service_packs if @service_packs
      @service_packs = {}
      tarifs.each do |tarif|
        @service_packs[tarif] = [tarif]
        common_services.each {|common_service| @service_packs[tarif] << common_service}
        tarif_options.each do |tarif_option|
          next if dependencies[tarif_option]['is_archived'.freeze] == true
          next if tarif_option_forbidden_to_switch_on_to_tarif?(tarif, tarif_option)
          @service_packs[tarif] << tarif_option
        end
      end
      @service_packs
    end
    
    def tarif_option_forbidden_to_switch_on_to_tarif?(tarif, tarif_option)
      !dependencies[tarif_option]['forbidden_tarifs'.freeze]['to_switch_on'.freeze].blank? and 
        dependencies[tarif_option]['forbidden_tarifs'.freeze]['to_switch_on'.freeze].include?(tarif)
    end
    
    def tarif_is_not_allowed_by_prerequisites_of_tarif_option?(tarif, tarif_option)
      !dependencies[tarif_option].try(:[], 'prerequisites'.freeze).blank? and 
        dependencies[tarif_option]['prerequisites'.freeze].include?(tarif) and
        !(dependencies[tarif_option]['prerequisites'.freeze] & tarifs).blank?
    end
    
    def service_packs_by_parts
      return @service_packs_by_parts if @service_packs_by_parts 
  #    raise(StandardError)
      @service_packs_by_parts = {}
      service_packs.each do |tarif, service_pack|
        @service_packs_by_parts[tarif] ||= {}
        service_pack.each do |service|
          (dependencies[service]['parts'.freeze] & parts).each do |part|
            @service_packs_by_parts[tarif][part] ||= []
            @service_packs_by_parts[tarif][part] << service
          end
        end
      end 
      @service_packs_by_parts
    end
  
    def service_packs_by_general_priority
      return @service_packs_by_general_priority if @service_packs_by_general_priority
      @service_packs_by_general_priority = {}
      service_packs_by_parts.each do |tarif, service_pack|
        @service_packs_by_general_priority[tarif] ||= {}
        service_pack.each do |part, services|
          @service_packs_by_general_priority[tarif][part] ||= {}
          services.each do |service|
            general_priority = dependencies[service]['general_priority'.freeze].try(:to_i)
            @service_packs_by_general_priority[tarif][part][general_priority] ||= []
            @service_packs_by_general_priority[tarif][part][general_priority] << service
          end
        end
      end
      @service_packs_by_general_priority
    end
  
    def tarif_option_by_compatibility
      return @tarif_option_by_compatibility if @tarif_option_by_compatibility
      @tarif_option_by_compatibility = {}
      @fobidden_combinations_by_service = {}
      if calculate_only_chosen_services
        service_packs_by_parts.each do |tarif, service_pack|
          @tarif_option_by_compatibility[tarif] ||= {}
          service_pack.each do |part, services|
            @tarif_option_by_compatibility[tarif][part] ||= {}
            services.each do |service|
              incompatibility_name = service.to_s
              @tarif_option_by_compatibility[tarif][part][incompatibility_name] = [service]
            end
  
  #      raise(StandardError, @tarif_option_by_compatibility)
            if tarif_option_by_compatibility[tarif][part].blank?
              @tarif_option_by_compatibility[tarif][part] = {""=>[]}
            end
          end
        end
      else
        service_packs_by_parts.each do |tarif, service_pack|
          @tarif_option_by_compatibility[tarif] ||= {}
          fobidden_combinations_by_service[tarif] ||= {}
          service_pack.each do |part, services|
            @tarif_option_by_compatibility[tarif][part] ||= {}
            fobidden_combinations_by_service[tarif][part] ||= {}
            if ['periodic'.freeze, 'onetime'.freeze].include?(part)
              periodic_incompatibility_name = 'special_periodic_for_tarif_list_generation'.freeze
              @tarif_option_by_compatibility[tarif][part][periodic_incompatibility_name] = services
            else
              services.each do |service|
                fobidden_combinations_by_service[tarif][part][service] ||= []
                incompatibility_groups = dependencies[service]['incompatibility'.freeze]
                incompatibility_groups.each do |incompatibility_name, incompatible_services|
                  @tarif_option_by_compatibility[tarif][part][incompatibility_name] ||= []
                  @tarif_option_by_compatibility[tarif][part][incompatibility_name] << service
                  integer_incompatible_services = incompatible_services.blank? ? [] : incompatible_services.map(&:to_i) 
                  fobidden_combinations_by_service[tarif][part][service] = fobidden_combinations_by_service[tarif][part][service] + integer_incompatible_services
                  fobidden_combinations_by_service[tarif][part][service].uniq!
                end
                
                if incompatibility_groups.blank? and !tarifs.include?(service) and !common_services.include?(service)
  #    raise(StandardError) if part == 'all-world-rouming/calls' and service == 405
                  @tarif_option_by_compatibility[tarif][part][service] = [service]
                end
              end
            end
            if @tarif_option_by_compatibility[tarif][part].blank?
              @tarif_option_by_compatibility[tarif][part] = {""=>[]}
            end
          end
        end
      end
      @tarif_option_by_compatibility
    end
  
    def tarif_option_combinations
      return @tarif_option_combinations if @tarif_option_combinations
      @tarif_option_combinations = {}
      fobidden_combinations_by_set_id = {}
      if calculate_only_chosen_services
        tarif_option_by_compatibility.each do |tarif, service_pack|
          @tarif_option_combinations[tarif] ||= {}
          service_pack.each do |part, incompatibility_groups|
            next if ['periodic'.freeze, 'onetime'.freeze].include?(part)
            @tarif_option_combinations[tarif][part] ||= {}
            services = incompatibility_groups.values.flatten.uniq
            tarif_set_id = tarif_set_id(services)
            @tarif_option_combinations[tarif][part][tarif_set_id] = services
          end
          
          uniq_services_in_tarif_option_combinations = @tarif_option_combinations[tarif].map{|c| c[1].map{|t| t[1]}}.flatten.compact.uniq
          (uniq_services_in_tarif_option_combinations & periodic_services).each do |service|
            @tarif_option_combinations[tarif]['periodic'.freeze] ||= {}
            @tarif_option_combinations[tarif]['periodic'.freeze][tarif_set_id([service])] = [service]
          end
          (uniq_services_in_tarif_option_combinations & onetime_services).each do |service|
            @tarif_option_combinations[tarif]['onetime'.freeze] ||= {}
            @tarif_option_combinations[tarif]['onetime'.freeze][tarif_set_id([service])] = [service]
          end
        end
      else      
        tarif_option_by_compatibility.each do |tarif, service_pack|
          @tarif_option_combinations[tarif] ||= {}
          fobidden_combinations_by_set_id[tarif] = {}
          service_pack.each do |part, incompatibility_groups|
            @tarif_option_combinations[tarif][part] ||= {}
            fobidden_combinations_by_set_id[tarif][part] ||= {}
            if ['periodic'.freeze, 'onetime'.freeze].include?(part)
              incompatibility_groups['special_periodic_for_tarif_list_generation'.freeze].each do |service|
                @tarif_option_combinations[tarif][part][service.to_s] = [service]
              end if incompatibility_groups['special_periodic_for_tarif_list_generation'.freeze]
            else
  #            raise(StandardError)
              incompatibility_groups.each do |incompatibility_group_name, incompatibility_group_1|
                incompatibility_group = incompatibility_group_1 + [nil]
                if @tarif_option_combinations[tarif][part].blank?
                  incompatibility_group.each do |service|
                    @tarif_option_combinations[tarif][part][service.to_s] = [service]
                    
                    fobidden_combinations_by_set_id[tarif][part][service.to_s] = fobidden_combinations_by_service[tarif][part][service] || []
                  end
                else
                  @tarif_option_combinations[tarif][part].dup.each do |current_tarif_set_id, tarif_option_combination|
                    incompatibility_group.each do |service|
                      if !fobidden_combinations_by_set_id[tarif][part][current_tarif_set_id].include?(service)

                        new_tarif_set = (@tarif_option_combinations[tarif][part][current_tarif_set_id] + [service]).compact.uniq.sort
                        new_tarif_set_id = tarif_set_id(new_tarif_set)
                        @tarif_option_combinations[tarif][part][new_tarif_set_id] = new_tarif_set
                        
                         
                        fobidden_combinations_by_set_id[tarif][part][new_tarif_set_id] = (fobidden_combinations_by_set_id[tarif][part][new_tarif_set_id] || []) + 
                          fobidden_combinations_by_set_id[tarif][part][current_tarif_set_id] + (fobidden_combinations_by_service[tarif][part][service] || [])
                        fobidden_combinations_by_set_id[tarif][part][new_tarif_set_id].uniq!  
                      end 
                    end
                  end
                  incompatibility_group.each do |service|
                    @tarif_option_combinations[tarif][part][service.to_s] ||= [service]
                  end
                end
              end                  
            end
          end
          uniq_services_in_tarif_option_combinations = @tarif_option_combinations[tarif].map{|c| c[1].map{|t| t[1]}}.flatten.compact.uniq
          (uniq_services_in_tarif_option_combinations & periodic_services).each do |service|
            @tarif_option_combinations[tarif]['periodic'.freeze] ||= {}
            @tarif_option_combinations[tarif]['periodic'.freeze][tarif_set_id([service])] = [service]
          end
          (uniq_services_in_tarif_option_combinations & onetime_services).each do |service|
            @tarif_option_combinations[tarif]['onetime'.freeze] ||= {}
            @tarif_option_combinations[tarif]['onetime'.freeze][tarif_set_id([service])] = [service]
          end
        end
      end
      raise(StandardError, @tarif_option_combinations) if false
      clean_tarif_option_combinations_from_extra_support_services_and_options_without_prerequisites
      reorder_tarif_option_combinations
      calculate_tarif_option_combinations_with_multiple_use
      @tarif_option_combinations
    end
    
    def clean_tarif_option_combinations_from_extra_support_services_and_options_without_prerequisites
      @tarif_option_combinations.each do |tarif, service_pack|
        service_pack.each do |part, tarif_sets|
          @tarif_option_combinations[tarif][part] ||= {}
          tarif_sets.each do |tarif_set_id, services|
            next if tarif_set_is_allowed_by_prerequisites?(tarif, services) and tarif_set_services_has_support_service?(part, services, tarif)
            @tarif_option_combinations[tarif][part].extract!(tarif_set_id)
          end
        end
      end
    end 
    
    def tarif_set_is_allowed_by_prerequisites?(tarif, tarif_set_services)
      tarif_set_services.all? do |tarif_option|
        condition = dependencies[tarif_option].try(:[], 'prerequisites'.freeze).blank? ? true :
          (tarif_set_services + [tarif]).any?{|service| dependencies[tarif_option]['prerequisites'.freeze].include?(service)}
        condition  
      end
    end
    
    def tarif_set_services_has_support_service?(part, tarif_set_services, tarif)
      tarif_set_services.all? do |support_service_id|
        condition = if support_services[part].try(:include?, support_service_id)
          used_support_services[part].try(:[], support_service_id).blank? ? false :
            (tarif_set_services + [tarif]).any?{|service| used_support_services[part][support_service_id].include?(service)}
        else
          true
        end
        condition
      end
    end
  
    def reorder_tarif_option_combinations
      unordered_tarif_option_combinations = tarif_option_combinations.dup
      @tarif_option_combinations = {}
      raise(StandardError, unordered_tarif_option_combinations) if false
      unordered_tarif_option_combinations.each do |tarif, service_pack|
        @tarif_option_combinations[tarif] ||= {}
        service_pack.each do |part, tarif_sets|
  
          @tarif_option_combinations[tarif][part] ||= {}
          tarif_sets.each do |tarif_set_id, services|
            if ['periodic'.freeze, 'onetime'.freeze].include?(part)
              @tarif_option_combinations[tarif][part][tarif_set_id] = services
            else
              new_services = services.sort do |a, b|
                next 1 if dependencies[a]['other_tarif_priority'.freeze]['lower'.freeze].include?(b)
                next -1 if dependencies[a]['other_tarif_priority'.freeze]['higher'.freeze].include?(b)
                next 1 if dependencies[b]['other_tarif_priority'.freeze]['higher'.freeze].include?(a)
                next -1 if dependencies[b]['other_tarif_priority'.freeze]['lower'.freeze].include?(a)
                next 1 if used_support_services[part].try(:[], a)
                next 1 if used_support_services[part].try(:[], b)
                0
              end
              raise(StandardError, [
                tarif_sets.keys,
                services, #service,
                new_services
                ]) if false and tarif_set_id == "8867_8869_8872"# and services[2] == service
              new_tarif_set_id = tarif_set_id(new_services)
              @tarif_option_combinations[tarif][part][new_tarif_set_id] = new_services
            end
          end
        end
      end
      raise(StandardError, @tarif_option_combinations) if false
    end
  
    def calculate_tarif_option_combinations_with_multiple_use
      ordered_tarif_option_combinations = tarif_option_combinations.dup
      @tarif_option_combinations = {}
      ordered_tarif_option_combinations.each do |tarif, service_pack|
        tarif_option_combinations[tarif] ||= {}
        service_pack.each do |part, tarif_sets|
  #        next if part == 'periodic'
          tarif_option_combinations[tarif][part] ||= {}
          tarif_sets.each do |tarif_set_id, services|
            new_services = []
            services.each do |service|
              next if service.blank?
              multiple_use = dependencies[service]['multiple_use'.freeze]
              new_services << service
            end
            new_tarif_set_id = tarif_set_id(new_services)
            tarif_option_combinations[tarif][part][new_tarif_set_id] = new_services
          end
        end
      end
    end 
    
    def tarif_sets_without_common_services
      return @tarif_sets_without_common_services if @tarif_sets_without_common_services
      @tarif_sets_without_common_services = {}
      tarifs.each do |tarif|  
        tarif_sets_without_common_services[tarif] ||= {}
        (parts - ['periodic'.freeze, 'onetime'.freeze]).each do |part|
          tarif_sets_without_common_services[tarif][part] ||= {}

          if tarif_option_combinations[tarif][part].blank?
            new_services = [tarif]
            new_tarif_set_id = tarif_set_id(new_services)
            tarif_sets_without_common_services[tarif][part][new_tarif_set_id] = new_services
          else
            tarif_option_combinations[tarif][part].each do |tarif_set_id, tarif_options|
              tarif_sets_without_common_services[tarif][part]["#{tarif}_#{tarif_set_id}"] = [tarif] + tarif_options
            end
          end
        end

        ['periodic'.freeze, 'onetime'.freeze].each do |periodic_part|
          tarif_sets_without_common_services[tarif][periodic_part] ||= {}
          tarif_option_combinations[tarif][periodic_part] ||= {}

          tarif_sets_without_common_services[tarif].each do |part, tarif_sets_without_common_services_by_part|    
            next if part == periodic_part
            
            tarif_sets_without_common_services_by_part.each do |tarif_set_id, services|
              services_that_depended_on.slice(*services).each do |main_depended_service, service_ids_that_depended_on|
                service_ids_that_depended_on.each do |service_that_depended_on|
                  new_periodic_services = [main_depended_service, service_that_depended_on]
                  new_tarif_set_id = "#{main_depended_service}_#{service_that_depended_on}"
                  tarif_sets_without_common_services[tarif][periodic_part][new_tarif_set_id] = new_periodic_services
                                      
                  tarif_option_combinations[tarif][periodic_part][new_tarif_set_id] ||= new_periodic_services                
                end
              end
            end
          end

          ((tarif_option_combinations[tarif][periodic_part].values.flatten + [tarif])).each do |service|
            tarif_sets_without_common_services[tarif][periodic_part][service.to_s] ||= [service]
          end
        end
      end
      @tarif_sets_without_common_services  
    end
    
    def tarif_sets
      return @tarif_sets if @tarif_sets
      @tarif_sets = {}; @allowed_common_services = {}
      tarif_sets_without_common_services.each do |tarif, tarif_sets_without_common_services_by_tarif|
        @tarif_sets[tarif] ||= {}; allowed_common_services[tarif] ||= {}
        tarif_sets_without_common_services_by_tarif.each do |part, tarif_sets_without_common_services_by_tarif_by_parts|
          @tarif_sets[tarif][part] ||= {}
          
          allowed_common_services[tarif][part] = check_allowed_common_services(common_services_by_parts[part] || [], tarif)
          
          if ['periodic'.freeze, 'onetime'.freeze].include?(part)
            tarif_sets_without_common_services_by_tarif_by_parts.each do |tarif_set_id, services|
              @tarif_sets[tarif][part][tarif_set_id] = services            
            end
            
            allowed_common_services[tarif][part].each do |common_service|
              common_services_id = tarif_set_id([common_service])
              @tarif_sets[tarif][part][common_services_id] = [common_service]
            end
          else
            tarif_sets_without_common_services_by_tarif_by_parts.each do |tarif_set_id, services|
              services_with_common_services = allowed_common_services[tarif][part] + services
              services_with_common_services_id = tarif_set_id(services_with_common_services)
              @tarif_sets[tarif][part][services_with_common_services_id] = services_with_common_services
            end
          end
        end
      end
      @tarif_sets
    end
  
    def check_allowed_common_services(common_services_to_check, tarif)
      result = []
      common_services_to_check.collect do |common_service|
        if !dependencies[common_service]['prerequisites'.freeze].blank? and dependencies[common_service]['prerequisites'.freeze].include?(tarif)
          result << common_service
        end
        
        if !dependencies[common_service]['forbidden_tarifs'.freeze]['to_switch_on'.freeze].blank? and !dependencies[common_service]['forbidden_tarifs'.freeze]['to_switch_on'.freeze].include?(tarif)
          result << common_service
        end
        
        if dependencies[common_service]['prerequisites'.freeze].blank? and dependencies[common_service]['forbidden_tarifs'.freeze]['to_switch_on'.freeze].blank?
          result << common_service
        end
      end
      result
    end
    
    def tarif_pathes
      return @tarif_pathes if @tarif_pathes
      @tarif_pathes = {}
      tarif_sets.each do |tarif, tari_sets_by_tarif|
        tari_sets_by_tarif.each do |part, tarif_sets_by_part|
          @tarif_pathes[part] ||= {}
          tarif_sets_by_part.each do |tarif_set_id, services|
            tarif_set_path = {}
            services.each do |service|
              tarif_set_path = {service => tarif_set_path}
            end
            @tarif_pathes[part].deep_merge!(tarif_set_path)
          end
        end
      end
      @tarif_pathes
    end
    
    def tarif_set_id(tarif_ids)
      tarif_ids.compact.join('_')
#      tarif_ids.collect {|tarif_id| tarif_id if tarif_id}.compact.join('_')
    end
  
  end  
end
