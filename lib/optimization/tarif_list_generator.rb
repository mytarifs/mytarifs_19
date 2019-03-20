#TODO рассмотреть возможность добавить исключение опций из оптимизации по cost factor (цена на единицу объема выше определенного порога)
module Optimization
  class TarifListGenerator  
    attr_reader :options, :operators, :tarifs, :common_services, :tarif_options             
    attr_accessor :all_services, :all_services_by_operator, :dependencies, :service_description, :uniq_parts_by_operator, :support_services, :used_support_services,
                  :all_services_by_parts, :common_services_by_parts, :service_packs, :service_packs_by_parts, :services_that_depended_on, :periodic_services, :onetime_services,
                  :service_packs_by_general_priority, :tarif_option_by_compatibility, :fobidden_combinations_by_service, :parts_by_service,
                  :tarif_option_combinations, :tarif_sets_without_common_services, :allowed_common_services, :tarif_sets                
    
    attr_accessor :tarif_options_slices, :tarif_options_count, :max_tarif_options_slice, :tarifs_slices, :tarifs_count, :max_tarifs_slice, :all_tarif_parts_count
    
    attr_reader :gp_tarif_option, :gp_tarif_without_limits, :gp_tarif_with_limits, :gp_tarif_option_with_limits, :gp_common_service, :all_parts,
                :parts_used_as_multiple
           
    attr_reader :calculate_with_multiple_use, :calculate_only_chosen_services, :calculate_with_fixed_services
    
    Parts = [
        'all-world-rouming/sms'.freeze, 'all-world-rouming/mms'.freeze, 'all-world-rouming/calls'.freeze, 'all-world-rouming/mobile-connection'.freeze,
        'own-country-rouming/sms'.freeze, 'own-country-rouming/mms'.freeze, 'own-country-rouming/calls'.freeze, 'own-country-rouming/mobile-connection'.freeze, 
        'onetime'.freeze, 'periodic'.freeze, #'mms'.freeze, 
        ]

    def self.test_tarif_set_checker
      options = {
        :tarif_list_generator_params => {:calculate_with_multiple_use => "true"},
        :services_by_operator => Customer::Info::ServiceChoices.
          services_from_session_to_optimization_format(Customer::Info::ServiceChoices.default_values(:admin)),
      }
      operator_to_check = 1023
      tarif_to_check = 802
      limited_tarifs = {:common_services => {1023 => [], 1025 => [], 1028 => [], 1030 => []}}#, :tarifs => {operator_to_check => [tarif_to_check]}}#, :tarif_options => {operator_to_check => [840, 850, 861, 882, 884, 885, 886]} }
  #    limited_tarifs = {:operators => [operator_to_check], :common_services => {operator_to_check => []}}#, :tarifs => {operator_to_check => [tarif_to_check]}}#, :tarif_options => {operator_to_check => [840, 850, 861, 882, 884, 885, 886]} }
  #    limited_tarifs = {:operators => [operator_to_check], :tarifs => {operator_to_check => [tarif_to_check]}, :common_services => {operator_to_check => []}}#, :tarif_options => {operator_to_check => [840, 850, 861, 882, 884, 885, 886]} }
      options.deep_merge!({:services_by_operator => limited_tarifs})
      generator = self.new(options)
      generator.calculate_tarif_sets_and_slices
      checker = Optimization::BaseTarifSetChecker.new({:tarif_list_generator => generator})
      split_by_parts = checker.sorted_parts(tarif_to_check).map{|p| generator.tarif_sets[tarif_to_check][p].size}
      parts_freq = checker.set_frequency_by_parts(tarif_to_check)
      start = Time.now
      res = checker.generate_all_tarif_sets
      finish = Time.now
      [res[0], res[1..3], split_by_parts, res[0].map{|t| t[1]}.sum, (finish - start)]#, generator.tarif_sets, checker.history]
    end   
    
    # Optimization::TarifListGenerator.speed_tester
    def self.speed_tester(number_of_circles = 1, calculate_all_tarifs = false)
      methods = {
        :initialize => [
          :set_operators_and_services, :set_constant, :set_parts, :set_generation_params, :check_input_from_options, :calculate_all_services,
          :load_dependencies, :load_services_that_depended_on, :load_periodic_services, :calculate_uniq_parts_by_operator, :calculate_parts_by_service,
          :calculate_all_services_by_parts, :calculate_common_services_by_parts
        ],
        :calculate_tarif_sets_and_slices => [
          :calculate_support_services, :calculate_used_support_services, :calculate_service_packs, :calculate_service_packs_by_parts,
          :calculate_service_packs_by_general_priority, :calculate_tarif_option_by_compatibility, :calculate_tarif_option_combinations,
          :clean_tarif_option_combinations_from_extra_support_services_and_options_without_prerequisites, :reorder_tarif_option_combinations,
          :calculate_tarif_option_combinations_with_multiple_use, :calculate_tarif_sets_without_common_services, :calculate_tarif_sets
        ]
      }
      privacy_id = 2; region_txt = 'moskva_i_oblast'
      operators = calculate_all_tarifs ? Customer::Info::ServiceChoices.operators : [1030]
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
        } 
      }
      tarif_list_generator = Optimization::TarifListGenerator.new(options)
      
      speed_results = {}
      
      start = Time.now
      number_of_circles.times do |number_of_circle|
        methods.each do |first_level_method, second_level_methods|
          speed_results[first_level_method] ||= 0.0
          start_first_level = Time.now
          second_level_methods.each do |second_level_method|
            speed_results[second_level_method] ||= 0.0
            start_second_level = Time.now
            tarif_list_generator.send(second_level_method)
            speed_results[second_level_method] += (Time.now - start_second_level)
          end
          speed_results[first_level_method] += (Time.now - start_first_level)
        end
      end
      puts
      puts
      puts speed_results.to_a.map{|item| "#{(item[1]/number_of_circles).to_s(:rounded, precision: 3)} = #{item[0]}"}
      puts "#{((Time.now - start)/number_of_circles).to_s(:rounded, precision: 3)} = Total"
      puts
    end        
    
    def initialize(options = {} )
      @options = options
      set_operators_and_services(options)
  #    raise(StandardError)
      set_constant
      set_parts
      set_generation_params(options)
      check_input_from_options
      calculate_all_services
      load_dependencies
      load_services_that_depended_on
      load_periodic_services
      calculate_uniq_parts_by_operator
      calculate_parts_by_service
      calculate_all_services_by_parts
      calculate_common_services_by_parts
    end
    
    def set_operators_and_services(options_1 = nil)
      options = options_1 ? options_1 : @options
      @operators = (!options[:services_by_operator][:operators].blank? ? options[:services_by_operator][:operators] : [1023, 1025, 1028, 1030])
      @tarifs = {1023 => [], 1025 => [], 1028 => [], 1030 => []}
      @common_services = {1023 => [], 1025 => [], 1028 => [], 1030 => []}
      @tarif_options = {1023 => [], 1025 => [], 1028 => [], 1030 => []}
      operators.each do |operator|
        tarifs[operator] = options[:services_by_operator][:tarifs][operator] if options and options[:services_by_operator][:tarifs] and options[:services_by_operator][:tarifs][operator]  
        common_services[operator] = options[:services_by_operator][:common_services][operator] if options and options[:services_by_operator][:common_services] and options[:services_by_operator][:common_services][operator]  
        tarif_options[operator] = options[:services_by_operator][:tarif_options][operator] if options and options[:services_by_operator][:tarif_options] and options[:services_by_operator][:tarif_options][operator]  
      end if operators
      all_tarifs_count = tarifs.map{|operator, tarif_by_operator| tarif_by_operator.size }.sum
      if all_tarifs_count == 0
        default_tarifs = {1023 => [], 1025 => [], 1028 => [100], 1030 => [200]}
        operators.each do |operator|
          tarifs[operator] = default_tarifs[operator]
        end
      end
    end
    
    def calculate_tarif_sets_and_slices(operator = nil, tarif =nil)
  #=begin
      calculate_support_services
      calculate_used_support_services
      calculate_service_packs(operator, tarif)
      calculate_service_packs_by_parts
      calculate_service_packs_by_general_priority
      calculate_tarif_option_by_compatibility
      calculate_tarif_option_combinations
      clean_tarif_option_combinations_from_extra_support_services_and_options_without_prerequisites
      reorder_tarif_option_combinations
      calculate_tarif_option_combinations_with_multiple_use if true # на будущее
      calculate_tarif_sets_without_common_services(operator, tarif)
      calculate_tarif_sets
  ##    calculate_final_tarif_sets
      
  #=end
    end
    
    def set_constant
      @gp_tarif_option = 320; @gp_tarif_without_limits = 321; @gp_tarif_with_limits = 322; @gp_tarif_option_with_limits =323; @gp_common_service = 324;    
    end
    
    def set_parts(parts = nil)
      if parts
        @all_parts = parts
      else
        @all_parts = [
          'all-world-rouming/sms'.freeze, 'all-world-rouming/mms'.freeze, 'all-world-rouming/calls'.freeze, 'all-world-rouming/mobile-connection'.freeze,
          'own-country-rouming/sms'.freeze, 'own-country-rouming/mms'.freeze, 'own-country-rouming/calls'.freeze, 'own-country-rouming/mobile-connection'.freeze, 
          'onetime'.freeze, 'periodic'.freeze, #'mms'.freeze, 
          ]
      end
      @parts_used_as_multiple = ['all-world-rouming/sms'.freeze, 'own-country-rouming/sms'.freeze, 'all-world-rouming/mms'.freeze, 'own-country-rouming/mms'.freeze, 
        'all-world-rouming/mobile-connection'.freeze, 'own-country-rouming/mobile-connection'.freeze ] & @all_parts #, 'mms'.freeze
    end
    
    def set_generation_params(options_1 = nil)
      options = options_1 ? options_1 : @options
      @calculate_with_multiple_use = options[:tarif_list_generator_params][:calculate_with_multiple_use] == 'true' ? true : false
      @calculate_only_chosen_services = options[:tarif_list_generator_params][:calculate_only_chosen_services] == 'true' ? true : false
      @calculate_with_fixed_services = options[:tarif_list_generator_params][:calculate_with_fixed_services] == 'true' ? true : false
    end
    
    def check_input_from_options    
      @operators = [] if !operators or !operators.is_a?(Array)
      @tarifs = {} if !tarifs or !tarifs.is_a?(Hash)
      @common_services = {} if !common_services or !common_services.is_a?(Hash)
      @tarif_options = {} if !tarif_options or !tarif_options.is_a?(Hash)
      operators.each do |operator|
        @tarifs[operator] = [] if !tarifs or !tarifs[operator] or !tarifs[operator].is_a?(Array)
        @common_services[operator] = [] if !common_services or !common_services[operator] or !common_services[operator].is_a?(Array)
        @tarif_options[operator] = [] if !tarif_options or !tarif_options[operator] or !tarif_options[operator].is_a?(Array)
      end    
    end
    
    def calculate_all_services
      @all_services = []; @all_services_by_operator = {}
      operators.each do |operator| 
        all_services_by_operator[operator] = tarifs[operator] + tarif_options[operator] + common_services[operator]
        @all_services +=  all_services_by_operator[operator]
      end
      all_services.uniq 
    end
    
    def load_dependencies
      @dependencies = {}; @service_description = {}
      TarifClass.where(:id => all_services).select("*".freeze).all.each do |r|
        service_description[r['id'.freeze]] = r
        dependencies[r['id'.freeze]] = r['dependency'.freeze]
      end    
    end
    
    def load_services_that_depended_on
      @services_that_depended_on = {}
  #TODO добавить индекс на (conditions->>'tarif_set_must_include_tarif_options')
  #TODO можно сразу выбирать уникальные значения сервисов
      Service::CategoryTarifClass.where(:tarif_class_id => all_services).
        where("(((conditions->>'tarif_set_must_include_tarif_options')::jsonb is not null) or ((conditions->>'tarif_set_must_include_tarif_options')::text != '[]'))").
        select("tarif_class_id, (conditions->>'tarif_set_must_include_tarif_options')::jsonb as tarif_set_must_include_tarif_options").uniq.each do |r|
#          dependent_services = eval(r['tarif_set_must_include_tarif_options'])
          dependent_services = (r['tarif_set_must_include_tarif_options']).map(&:to_i)
          tarif_class_id = r['tarif_class_id'.freeze].to_i
          @services_that_depended_on[tarif_class_id] ||= []
          @services_that_depended_on[tarif_class_id] += ((dependent_services & all_services) - @services_that_depended_on[tarif_class_id])
      end    
      raise(StandardError, @services_that_depended_on) if false
    end
    
    def load_periodic_services
      @periodic_services = []; @onetime_services = []
      Service::CategoryTarifClass.where(:tarif_class_id => all_services).where.not(:service_category_periodic_id => nil).select(:tarif_class_id).uniq.each do |r|
        raise(StandardError, @periodic_services) if false
          tarif_class_id = r['tarif_class_id'.freeze].to_i
          @periodic_services << tarif_class_id
      end    
      Service::CategoryTarifClass.where(:tarif_class_id => all_services).where.not(:service_category_one_time_id => nil).select(:tarif_class_id).uniq.each do |r|
          tarif_class_id = r['tarif_class_id'.freeze].to_i
          @onetime_services << tarif_class_id
      end    
    end
    
    def calculate_uniq_parts_by_operator
      @uniq_parts_by_operator = {}
      all_services_by_operator.each do |operator, services|
        @uniq_parts_by_operator[operator] ||= []
        services.each do |service|
          @uniq_parts_by_operator[operator] += ((dependencies[service] || {'parts' => []})['parts'.freeze] & all_parts) - @uniq_parts_by_operator[operator]; 
        end
      end
    end
    
    def calculate_parts_by_service
      @parts_by_service = {}
      all_services_by_operator.each do |operator, services|
        services.each do |service|
          parts_by_service[service] = []
          (dependencies[service]['parts'.freeze] & all_parts).each do |part|
            parts_by_service[service] << part 
          end
        end      
      end
    end
    
    def calculate_all_services_by_parts
      @all_services_by_parts = {}
      all_services_by_operator.each do |operator, services|
        all_services_by_parts[operator] = {}
        uniq_parts_by_operator[operator].each do |part|
          all_services_by_parts[operator][part] = []
        end
        
        services.each do |service|
          (dependencies[service]['parts'.freeze] & all_parts).each do |part|
            all_services_by_parts[operator][part] << service
          end
        end      
      end
    end
    
    def calculate_common_services_by_parts
      @common_services_by_parts = {}
      common_services.each do |operator, services|
        common_services_by_parts[operator] = {}
        uniq_parts_by_operator[operator].each do |part|
          common_services_by_parts[operator][part] = []
        end if uniq_parts_by_operator and uniq_parts_by_operator[operator] 
        
        services.each do |service|
          (dependencies[service]['parts'.freeze] & all_parts).each do |part|
            common_services_by_parts[operator][part] << service
          end
        end      
      end
    end
    
    def calculate_support_services
      @support_services = {}
      query_1 = TarifClass.
      select("tarif_classes.id as tarif_class_id, count(service_category_groups.id) as service_category_group_count, 
        jsonb_array_elements((tarif_classes.dependency->'parts')::jsonb) as part").
      joins("left join service_category_groups on service_category_groups.tarif_class_id = tarif_classes.id").
      where(:tarif_classes => {:id => all_services}).
      group("part, tarif_classes.id").
      having("count(service_category_groups.id) = 0")
      
      TarifClass.find_by_sql("with query_1 as (#{query_1.to_sql}) select array_agg(tarif_class_id) as tarif_class_ids, part from query_1 group by part").map do |row| 
        support_services[row.part] ||= row.tarif_class_ids
      end
    end
    
    def calculate_used_support_services
      @used_support_services = {}
      query = Service::CategoryGroup.select(" array_agg(distinct service_category_groups.tarif_class_id) as tarif_class_ids,
              jsonb_array_elements((service_category_tarif_classes.conditions->'parts')::jsonb) as part,
              jsonb_array_elements((service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options')::jsonb) as support_service_id").
      joins(:service_category_tarif_classes).
      where("json_array_length(service_category_tarif_classes.conditions->'tarif_set_must_include_tarif_options') > 0").
      where(:tarif_class_id => all_services).
      group("part, support_service_id").map do |row| 
        used_support_services[row.part] ||= {}
        used_support_services[row.part][row.support_service_id] = row.tarif_class_ids
      end
    end
    
    def calculate_service_packs(operator_1 = nil, tarif_1 = nil)
      @service_packs = {}
      (operator_1 ? [operator_1] : operators).each do |operator| 
        (tarif_1 ? [tarif_1] : tarifs[operator]).each do |tarif|
          service_packs[tarif] = [tarif]
          common_services[operator].each {|common_service| service_packs[tarif] << common_service}
          tarif_options[operator].each do |tarif_option|
            next if dependencies[tarif_option]['is_archived'.freeze] == true
            next if tarif_option_forbidden_to_switch_on_to_tarif?(tarif, tarif_option)
            service_packs[tarif] << tarif_option
          end
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
    
    def calculate_service_packs_by_parts
  #    raise(StandardError)
      @service_packs_by_parts = {}
      service_packs.each do |tarif, service_pack|
        @service_packs_by_parts[tarif] ||= {}
        service_pack.each do |service|
          (dependencies[service]['parts'.freeze] & all_parts).each do |part|
            @service_packs_by_parts[tarif][part] ||= []
            @service_packs_by_parts[tarif][part] << service
          end
        end
      end 
    end
  
    def calculate_service_packs_by_general_priority
      @service_packs_by_general_priority = {}
      service_packs_by_parts.each do |tarif, service_pack|
        service_packs_by_general_priority[tarif] ||= {}
        service_pack.each do |part, services|
          service_packs_by_general_priority[tarif][part] ||= {}
          services.each do |service|
            general_priority = dependencies[service]['general_priority'.freeze].try(:to_i)
            service_packs_by_general_priority[tarif][part][general_priority] ||= []
            service_packs_by_general_priority[tarif][part][general_priority] << service
          end
        end
      end
    end
  
    def calculate_tarif_option_by_compatibility
  #TODO Разобраться что делать когда одна опция несовместима с двумя другими, которые между собой совместимы    
      @tarif_option_by_compatibility = {}
      @fobidden_combinations_by_service = {}
      if calculate_only_chosen_services or calculate_with_fixed_services
        service_packs_by_parts.each do |tarif, service_pack|
          tarif_option_by_compatibility[tarif] ||= {}
          service_pack.each do |part, services|
            tarif_option_by_compatibility[tarif][part] ||= {}
            services.each do |service|
              incompatibility_name = service.to_s
              tarif_option_by_compatibility[tarif][part][incompatibility_name] = [service]
            end
  
  #      raise(StandardError, @tarif_option_by_compatibility)
            if tarif_option_by_compatibility[tarif][part].blank?
              tarif_option_by_compatibility[tarif][part] = {""=>[]}
            end
          end
        end
      else
        service_packs_by_parts.each do |tarif, service_pack|
          tarif_option_by_compatibility[tarif] ||= {}
          fobidden_combinations_by_service[tarif] ||= {}
          service_pack.each do |part, services|
            tarif_option_by_compatibility[tarif][part] ||= {}
            fobidden_combinations_by_service[tarif][part] ||= {}
            if ['periodic'.freeze, 'onetime'.freeze].include?(part)
              periodic_incompatibility_name = 'special_periodic_for_tarif_list_generation'.freeze
              tarif_option_by_compatibility[tarif][part][periodic_incompatibility_name] = services
            else
              services.each do |service|
                fobidden_combinations_by_service[tarif][part][service] ||= []
                incompatibility_groups = dependencies[service]['incompatibility'.freeze]
                incompatibility_groups.each do |incompatibility_name, incompatible_services|
                  tarif_option_by_compatibility[tarif][part][incompatibility_name] ||= []
                  tarif_option_by_compatibility[tarif][part][incompatibility_name] << service
                  integer_incompatible_services = incompatible_services.blank? ? [] : incompatible_services.map(&:to_i) 
                  fobidden_combinations_by_service[tarif][part][service] = fobidden_combinations_by_service[tarif][part][service] + integer_incompatible_services
                  fobidden_combinations_by_service[tarif][part][service].uniq!
                end
                
                operator = service_description[service][:operator_id].to_i
                if incompatibility_groups.blank? and !tarifs[operator].include?(service) and !common_services[operator].include?(service)
  #    raise(StandardError) if part == 'all-world-rouming/calls' and service == 405
                  tarif_option_by_compatibility[tarif][part][service] = [service]
                end
              end
            end
            if tarif_option_by_compatibility[tarif][part].blank?
              tarif_option_by_compatibility[tarif][part] = {""=>[]}
            end
          end
        end
      end
  #    raise(StandardError, [tarif_option_by_compatibility ])
    end
  
    def calculate_tarif_option_combinations
      @tarif_option_combinations = {}
      fobidden_combinations_by_set_id = {}
      if calculate_only_chosen_services or calculate_with_fixed_services
        tarif_option_by_compatibility.each do |tarif, service_pack|
          tarif_option_combinations[tarif] ||= {}
          service_pack.each do |part, incompatibility_groups|
            next if ['periodic'.freeze, 'onetime'.freeze].include?(part)
            tarif_option_combinations[tarif][part] ||= {}
            services = incompatibility_groups.values.flatten.uniq
            tarif_set_id = tarif_set_id(services)
            tarif_option_combinations[tarif][part][tarif_set_id] = services
          end
          
          uniq_services_in_tarif_option_combinations = tarif_option_combinations[tarif].map{|c| c[1].map{|t| t[1]}}.flatten.compact.uniq
          (uniq_services_in_tarif_option_combinations & periodic_services).each do |service|
            tarif_option_combinations[tarif]['periodic'.freeze] ||= {}
            tarif_option_combinations[tarif]['periodic'.freeze][tarif_set_id([service])] = [service]
          end
          (uniq_services_in_tarif_option_combinations & onetime_services).each do |service|
            tarif_option_combinations[tarif]['onetime'.freeze] ||= {}
            tarif_option_combinations[tarif]['onetime'.freeze][tarif_set_id([service])] = [service]
          end
        end
      else      
        tarif_option_by_compatibility.each do |tarif, service_pack|
          tarif_option_combinations[tarif] ||= {}
          fobidden_combinations_by_set_id[tarif] = {}
          service_pack.each do |part, incompatibility_groups|
            tarif_option_combinations[tarif][part] ||= {}
            fobidden_combinations_by_set_id[tarif][part] ||= {}
            if ['periodic'.freeze, 'onetime'.freeze].include?(part)
              incompatibility_groups['special_periodic_for_tarif_list_generation'.freeze].each do |service|
                tarif_option_combinations[tarif][part][service.to_s] = [service]
              end if incompatibility_groups['special_periodic_for_tarif_list_generation'.freeze]
            else
  #            raise(StandardError)
              incompatibility_groups.each do |incompatibility_group_name, incompatibility_group_1|
                incompatibility_group = incompatibility_group_1 + [nil]
                if tarif_option_combinations[tarif][part].blank?
                  incompatibility_group.each do |service|
                    tarif_option_combinations[tarif][part][service.to_s] = [service]
                    
                    fobidden_combinations_by_set_id[tarif][part][service.to_s] = fobidden_combinations_by_service[tarif][part][service] || []
                  end
                else
                  tarif_option_combinations[tarif][part].dup.each do |current_tarif_set_id, tarif_option_combination|
                    incompatibility_group.each do |service|
                      if !fobidden_combinations_by_set_id[tarif][part][current_tarif_set_id].include?(service)

                        new_tarif_set = (tarif_option_combinations[tarif][part][current_tarif_set_id] + [service]).compact.uniq.sort
                        new_tarif_set_id = tarif_set_id(new_tarif_set)
                        tarif_option_combinations[tarif][part][new_tarif_set_id] = new_tarif_set
                        
                         
                        fobidden_combinations_by_set_id[tarif][part][new_tarif_set_id] = (fobidden_combinations_by_set_id[tarif][part][new_tarif_set_id] || []) + 
                          fobidden_combinations_by_set_id[tarif][part][current_tarif_set_id] + (fobidden_combinations_by_service[tarif][part][service] || [])
                        fobidden_combinations_by_set_id[tarif][part][new_tarif_set_id].uniq!  
                      end 
                    end
                  end
                  incompatibility_group.each do |service|
                    tarif_option_combinations[tarif][part][service.to_s] ||= [service]
                  end
                end
              end                  
            end
          end
          uniq_services_in_tarif_option_combinations = tarif_option_combinations[tarif].map{|c| c[1].map{|t| t[1]}}.flatten.compact.uniq
          (uniq_services_in_tarif_option_combinations & periodic_services).each do |service|
            tarif_option_combinations[tarif]['periodic'.freeze] ||= {}
            tarif_option_combinations[tarif]['periodic'.freeze][tarif_set_id([service])] = [service]
          end
          (uniq_services_in_tarif_option_combinations & onetime_services).each do |service|
            tarif_option_combinations[tarif]['onetime'.freeze] ||= {}
            tarif_option_combinations[tarif]['onetime'.freeze][tarif_set_id([service])] = [service]
          end
        end
      end
      raise(StandardError, tarif_option_combinations) if false
    end
    
    def clean_tarif_option_combinations_from_extra_support_services_and_options_without_prerequisites
      tarif_option_combinations.each do |tarif, service_pack|
        service_pack.each do |part, tarif_sets|
          tarif_option_combinations[tarif][part] ||= {}
          tarif_sets.each do |tarif_set_id, services|
            raise(StandardError, tarif_option_combinations) if false and tarif_set_id == "315_8841"
            next if tarif_set_is_allowed_by_prerequisites?(tarif, services) and tarif_set_services_has_support_service?(part, services, tarif)
            tarif_option_combinations[tarif][part].extract!(tarif_set_id)
          end
        end
      end
      raise(StandardError, tarif_option_combinations) if false
    end 
    
    def tarif_set_is_allowed_by_prerequisites?(tarif, tarif_set_services)
      tarif_set_services.all? do |tarif_option|
        condition = dependencies[tarif_option].try(:[], 'prerequisites'.freeze).blank? ? true :
          (tarif_set_services + [tarif]).any?{|service| dependencies[tarif_option]['prerequisites'.freeze].include?(service)}
        raise(StandardError) if false and tarif_set_services == [315, 8841] and !condition
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
        raise(StandardError, [
          support_service_id,
          support_services[part].try(:[], support_service_id)
        ]) if false and support_service_id == 8853 
        condition
      end
    end
  
    def reorder_tarif_option_combinations
      unordered_tarif_option_combinations = tarif_option_combinations.dup
      @tarif_option_combinations = {}
      raise(StandardError, unordered_tarif_option_combinations) if false
      unordered_tarif_option_combinations.each do |tarif, service_pack|
        tarif_option_combinations[tarif] ||= {}
        service_pack.each do |part, tarif_sets|
  
          tarif_option_combinations[tarif][part] ||= {}
          tarif_sets.each do |tarif_set_id, services|
            if ['periodic'.freeze, 'onetime'.freeze].include?(part)
              tarif_option_combinations[tarif][part][tarif_set_id] = services
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
              tarif_option_combinations[tarif][part][new_tarif_set_id] = new_services
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
  #TODO разобраться когда можно использовать multiple_use (для каких parts), и связать с параметрами оптимизации 
              break if false #calculate_with_multiple_use and multiple_use and parts_used_as_multiple.include?(part)
            end
            new_tarif_set_id = tarif_set_id(new_services)
            tarif_option_combinations[tarif][part][new_tarif_set_id] = new_services
          end
        end
      end
  #    raise(StandardError)
    end 
    
    def calculate_tarif_sets_without_common_services(operator_1 = nil, tarif_1 = nil)
      @tarif_sets_without_common_services = {}
      (operator_1 ? [operator_1] : operators).each do |operator|     
        (tarif_1 ? [tarif_1] : tarifs[operator]).each do |tarif|  
          operator = service_description[tarif][:operator_id].to_i
          tarif_sets_without_common_services[tarif] ||= {}
          (all_parts - ['periodic'.freeze, 'onetime'.freeze]).each do |part|
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
      end
  
  #    combination_names = []
  #    part = 'own-country-rouming/mobile-connection' #'all-world-rouming/mobile-connection'
  #    tarif_option_combinations[208][part].each{|k,v| combination_names << v.map{|s| service_description[s]['name']}}
  #    raise(StandardError, combination_names)
  
    end
    
    def calculate_tarif_sets
      @tarif_sets = {}; @allowed_common_services = {}
      tarif_sets_without_common_services.each do |tarif, tarif_sets_without_common_services_by_tarif|
        operator = service_description[tarif][:operator_id].to_i
        tarif_sets[tarif] ||= {}; allowed_common_services[tarif] ||= {}
        tarif_sets_without_common_services_by_tarif.each do |part, tarif_sets_without_common_services_by_tarif_by_parts|
          tarif_sets[tarif][part] ||= {}
          
          allowed_common_services[tarif][part] = check_allowed_common_services(common_services_by_parts[operator][part] || [], tarif)
          
          if ['periodic'.freeze, 'onetime'.freeze].include?(part)
            tarif_sets_without_common_services_by_tarif_by_parts.each do |tarif_set_id, services|
              tarif_sets[tarif][part][tarif_set_id] = services            
            end
            
            allowed_common_services[tarif][part].each do |common_service|
              common_services_id = tarif_set_id([common_service])
              tarif_sets[tarif][part][common_services_id] = [common_service]
            end
          else
            tarif_sets_without_common_services_by_tarif_by_parts.each do |tarif_set_id, services|
              services_with_common_services = allowed_common_services[tarif][part] + services
              services_with_common_services_id = tarif_set_id(services_with_common_services)
              tarif_sets[tarif][part][services_with_common_services_id] = services_with_common_services
            end
          end
        end
      end
      raise(StandardError, @tarif_sets) if false
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
    
    def tarif_set_id(tarif_ids)
      tarif_ids.compact.join('_')
#      tarif_ids.collect {|tarif_id| tarif_id if tarif_id}.compact.join('_')
    end
  
  end  
end
