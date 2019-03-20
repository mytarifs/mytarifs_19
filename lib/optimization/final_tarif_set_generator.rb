module Optimization
  class FinalTarifSetGenerator
    attr_reader :if_save_history, :history
    attr_reader :indexed_tarif_set, :indexed_tarif_set_ids, :sorted_parts
  
    def initialize(options = {}, performance_checker)
#      @performance_checker = performance_checker
      @history = {}
      @if_save_history = options[:if_save_history] || false
    end
    
    def calculate_final_tarif_sets(tarif_cost_calculator, tarif_id, tarif_results, service_packs_by_parts, tarif_sets, common_services_by_parts, services_that_depended_on)    
      tarif_set_checker = init_tarif_set_checker(tarif_id, tarif_results, service_packs_by_parts, tarif_sets, common_services_by_parts)
      current_value_calculator = init_current_value_calculator(tarif_id, tarif_results, tarif_sets, services_that_depended_on)
      
      result = []; i = 0; j = 0
      j_max = 30000000000        
      print_period = 1000000000
      n_last_results = 1
      
      tarif_set_checker.iterate(current_value_calculator, tarif_cost_calculator) do |current_tarif_set, current_value, if_valid, if_complete, if_move_based_on_value|
        if if_save_history
          history ||= []
          history << current_tarif_set 
        end

#        puts [current_tarif_set, [if_valid, if_complete, if_move_based_on_value]].to_s

        if if_valid and if_complete and if_move_based_on_value
          result << [current_value, tarif_set_checker.tarif_set_name(current_tarif_set), current_tarif_set, j]
          result = result[-n_last_results..-1] if result.size > n_last_results

#          puts [current_tarif_set, [if_valid, if_complete, if_move_based_on_value]].to_s

          i += 1
        end           
        break if j > j_max
        j += 1
      end
      final_result = {}
      result.map do |r| 
        final_tarif_set_name = r[1]
        final_result[final_tarif_set_name] = current_value_calculator.more_detailed_value(r[2])
      end if true
      raise(StandardError, [
        sorted_parts, "##############", tarif_results, "#############", tarif_sets, "##################", result, final_result
      ]) if false
      final_result
    end
  
    def init_tarif_set_checker(tarif_id, tarif_results, service_packs_by_parts, tarif_sets, common_services_by_parts)
      service_packs_by_parts_without_common_services = {}
      service_packs_by_parts.each{|part, services| service_packs_by_parts_without_common_services[part] = services - common_services_by_parts[part] }
      init_sorted_parts(tarif_results)
      init_indexed_tarif_set(tarif_results, tarif_sets_without_common_services(tarif_sets, common_services_by_parts))
  
      options = {
        :tarif_id => tarif_id,
        :service_packs_by_parts => service_packs_by_parts_without_common_services,
        :sorted_parts => sorted_parts,
        :indexed_tarif_set => indexed_tarif_set,
      }
  #    raise(StandardError, options)
      tarif_set_checker = TarifSetChecker.new(options, @performance_checker)
      Customer::Stat::NewOptimizatorPerformanceChecker.apply(tarif_set_checker) if @performance_checker
      tarif_set_checker
    end
    
    def init_current_value_calculator(tarif_id, tarif_results, tarif_sets, services_that_depended_on)
      options = {
        :tarif_id => tarif_id,
        :sorted_parts => sorted_parts,
        :indexed_tarif_set => indexed_tarif_set,
        :indexed_tarif_set_ids => indexed_tarif_set_ids,
        :tarif_results => tarif_results,
        :tarif_sets => tarif_sets_without_common_services,      
        :services_that_depended_on => services_that_depended_on,
      }
      current_value_calculator = CurrentValueCalculator.new(options, @performance_checker) 
      Customer::Stat::NewOptimizatorPerformanceChecker.apply(current_value_calculator) if @performance_checker
      current_value_calculator
    end
  
    def tarif_sets_without_common_services(tarif_sets = nil, common_services_by_parts = nil)
      raise(StandardError, [
        tarif_sets
      ]) if false
      return @tarif_sets_without_common_services if @tarif_sets_without_common_services
      @tarif_sets_without_common_services = {}
      tarif_sets.each do |part, tarif_sets_by_part|
        @tarif_sets_without_common_services[part] ||= {}
        tarif_sets_by_part.each do |tarif_set_id, tarif_set_services|
          @tarif_sets_without_common_services[part][tarif_set_id] = tarif_set_services - common_services_by_parts[part]
        end
      end
      @tarif_sets_without_common_services
    end
  
    def init_sorted_parts(tarif_results)
      @sorted_parts = (tarif_results.keys - ['periodic', 'onetime']).sort_by{|p| (tarif_results[p].keys || []).size}
    end
    
    def init_indexed_tarif_set(tarif_results, tarif_sets_without_common_services)
      @indexed_tarif_set ||= []; @indexed_tarif_set_ids ||= []
      sorted_parts.each_with_index do |part, part_index|
        @indexed_tarif_set[part_index] ||= []; @indexed_tarif_set_ids[part_index] ||= []
        sorted_tarif_results_by_part_keys = tarif_results[part].keys.sort_by do |part_set_id| 
          raise(StandardError, [
            part_set_id, tarif_sets_without_common_services.keys, part, tarif_sets_without_common_services[part]
          ]) if tarif_sets_without_common_services[part][part_set_id].nil?
          tarif_results[part][part_set_id] + (tarif_sets_without_common_services[part][part_set_id] || []).size.to_f/100.0
        end
  
        sorted_tarif_results_by_part_keys.each_with_index do |part_set_id, part_set_index|
          @indexed_tarif_set[part_index][part_set_index] = tarif_sets_without_common_services[part][part_set_id]
          @indexed_tarif_set_ids[part_index][part_set_index] = part_set_id
        end
      end
      @indexed_tarif_set
    end
  
    def set_frequency_by_parts(tarif_sets)
      sorted_parts.map{|p| (tarif_sets[p].keys || []).size }
    end
    
    class CurrentValueCalculator
      attr_reader :tarif_id, :sorted_parts, :indexed_tarif_set, :indexed_tarif_set_ids, :tarif_results, :tarif_sets, :services_that_depended_on
  
      def initialize(options, performance_checker)
        @performance_checker = performance_checker
        @tarif_id = options[:tarif_id]
        @sorted_parts = options[:sorted_parts]
        @indexed_tarif_set = options[:indexed_tarif_set]
        @indexed_tarif_set_ids = options[:indexed_tarif_set_ids]
        @tarif_results = options[:tarif_results]
        @tarif_sets = options[:tarif_sets]      
        @services_that_depended_on = options[:services_that_depended_on]
      end
      
      def more_detailed_value(final_tarif_set)
        result = {}
        full_set = min_possible_set(final_tarif_set)
        raise(StandardError, [
          final_tarif_set, 
        ]) if false
        
        full_set[:set].each_with_index do |part_set_index, part_index|
          part = sorted_parts[part_index]
          part_set_id = indexed_tarif_set_ids[part_index][part_set_index]
          result[part] ||= {}
          result[part][part_set_id] ||= []
          result[part][part_set_id] << tarif_results[part][part_set_id]
        end
  
        ['periodic', 'onetime'].each do |part|          
          service_that_depended_on_from_tarif_set = tarif_set_for_service_that_depended_on(full_set[:services])
          service_that_depended_on_from_tarif_set_name = service_that_depended_on_from_tarif_set.join("_")        
          result[part] ||= {}
          result[part][service_that_depended_on_from_tarif_set_name] ||= []
          result[part][service_that_depended_on_from_tarif_set_name] << tarif_results[part][service_that_depended_on_from_tarif_set_name]
  
          (full_set[:services] - service_that_depended_on_from_tarif_set).each do |service|
            if tarif_results[part].try(:[], service.to_s)
              result[part][service.to_s] ||= []
              result[part][service.to_s] << tarif_results[part][service.to_s] 
            end
          end 
        end      
        result      
      end
      
      def detailed_value(final_tarif_set)
        result = {}
        full_set = min_possible_set(final_tarif_set)
        
        full_set[:set].each_with_index do |part_set_index, part_index|
          part = sorted_parts[part_index]
          part_set_id = indexed_tarif_set_ids[part_index][part_set_index]
          result[part] ||= 0.0 
          result[part] += tarif_results[part][part_set_id]
        end
        ['periodic', 'onetime'].each do |part|
          result[part] ||= 0.0
  
          service_that_depended_on_from_tarif_set = tarif_set_for_service_that_depended_on(full_set[:services])
          service_that_depended_on_from_tarif_set_name = service_that_depended_on_from_tarif_set.join("_")        
          result[part] += tarif_results[part][service_that_depended_on_from_tarif_set_name]
  
          (full_set[:services] - service_that_depended_on_from_tarif_set).each do |service|
            result[part] += tarif_results[part][service.to_s] if tarif_results[part].try(:[], service.to_s)
          end 
        end      
        result      
      end
      
      def calculate(tarif_cost_calculator, current_tarif_set)
        full_set = min_possible_set(current_tarif_set)
        min_possible_value(full_set) + fixed_value(tarif_cost_calculator, full_set)
      end
      
      def min_possible_value(full_set)
        result = 0.0
        full_set[:set].each_with_index do |part_set_index, part_index|
          part = sorted_parts[part_index]
          part_set_id = indexed_tarif_set_ids[part_index][part_set_index] 
  
          result += tarif_results[part][part_set_id]
        end
        result
      end
      
      def fixed_value(tarif_cost_calculator, full_set)
        result = 0.0
        ['periodic', 'onetime'].each do |part|
          tarif_results[part] ||= {}
  
          service_that_depended_on_from_tarif_set = tarif_set_for_service_that_depended_on(full_set[:services])
          service_that_depended_on_from_tarif_set_name = service_that_depended_on_from_tarif_set.join("_")        
          tarif_results[part][service_that_depended_on_from_tarif_set_name] = tarif_cost_calculator.calculate_tarif_set(part, service_that_depended_on_from_tarif_set)[0] if 
            !tarif_results[part].try(:[], service_that_depended_on_from_tarif_set_name)
          result += tarif_results[part][service_that_depended_on_from_tarif_set_name]
  
          raise(StandardError, [
            full_set
          ]) if part == 'onetime' and service_that_depended_on_from_tarif_set_name == "456_113_470_477_493_495"


          (full_set[:services] - service_that_depended_on_from_tarif_set).each do |service|
            result += tarif_results[part][service.to_s] if tarif_results[part].try(:[], service.to_s)
          end 
        end
        result
      end
      
      def tarif_set_for_service_that_depended_on(full_set_services)
        dependen_services = services_that_depended_on.slice(*(full_set_services)).values.flatten.uniq & full_set_services
        depended_on_services = services_that_depended_on.slice(*(full_set_services)).map{|ds, ds_on| ds if !(ds_on & dependen_services).blank?}.compact.uniq
        result = depended_on_services + dependen_services
#        result = [tarif_id] + (depended_on_services - [tarif_id]) + dependen_services
=begin        
        services_that_depended_on_service_ids = services_that_depended_on.slice(*(full_set_services)).keys.map(&:to_i)
        result_0 = [tarif_id] & full_set_services
        result_1 = (services_that_depended_on_service_ids & full_set_services) - result_0
        result_3 = []
        full_set_services.each do |service|
          result_3 += (services_that_depended_on[service] || []) & full_set_services
        end
        result_2 = (result_1 & result_3) - result_0
        result = result_0 + (result_1 - result_2).compact.uniq.sort + result_2.compact.uniq.sort + (result_3 - result_2 - result_0).compact.uniq.sort
=end        
        result
      end
      
      def min_possible_set(current_tarif_set)
        result = {}
        result[:set] = current_tarif_set[:set].deep_dup
        result[:services] = (current_tarif_set[:sets][current_tarif_set[:current][0]] + indexed_tarif_set[current_tarif_set[:current][0]][current_tarif_set[:current][1]]).uniq #advanced
        (current_tarif_set[:current][0] + 1..sorted_parts.size - 1).each do |part_index|
          part_set_index = 0
          result[:set] << part_set_index
          part = sorted_parts[part_index]
          
          result[:services] += (indexed_tarif_set[part_index][part_set_index] - result[:services])
        end
        raise(StandardError, [
          result, [current_tarif_set[:current][0] + 1, sorted_parts.size - 1]
        ]) if false and current_tarif_set == {:set=>[0], :current=>[0, 0], :sets=>[[]]}
        result
      end
    end  
  
    class TarifSetChecker
      attr_reader :tarif_id, :service_packs_by_parts, :sorted_parts, :indexed_tarif_set, :parts_services
      
      def initialize(options, performance_checker)
        @performance_checker = performance_checker
        @tarif_id = options[:tarif_id]
        @service_packs_by_parts = options[:service_packs_by_parts]
        @sorted_parts = options[:sorted_parts]
        @indexed_tarif_set = options[:indexed_tarif_set]
        init_parts_services
      end
      
      def init_parts_services
        @parts_services = {}
        sorted_parts.each_with_index do |part, part_index|
          @parts_services[part_index] = part_index.times.map{|p| service_packs_by_parts[sorted_parts[p]]}.flatten.uniq
        end
      end
      
      def iterate(value_calculator, tarif_cost_calculator)
        current_value = 1000000000.0
        current_tarif_set = {:set => [0], :current => [0,0], :sets => [[]]} #indexed_tarif_set[0][0]
        is_first_valid_tarif_set_calculated = false
        while current_tarif_set
          new_value = value_calculator.calculate(tarif_cost_calculator, current_tarif_set)
          
          is_better = (new_value < current_value) ? true : false        
          if_valid = if_tarif_set_valid(current_tarif_set)
          if_complete = if_tarif_set_complete(current_tarif_set, sorted_parts.size)
          is_first_valid_tarif_set_calculated = if_valid and if_complete if !is_first_valid_tarif_set_calculated
          if_move_based_on_value = is_first_valid_tarif_set_calculated ? is_better : true
  
          current_value = new_value if if_complete and if_valid and is_better
          
          yield [current_tarif_set, current_value, if_valid, if_complete, if_move_based_on_value]
          current_tarif_set = next_part_set(current_tarif_set, if_valid, if_complete, if_move_based_on_value)
        end
      end
      
      def next_part_set(current_tarif_set, if_valid, if_complete, if_move_based_on_value)      
        current_tarif_set = if if_valid and if_move_based_on_value
          if if_complete
            move_down(current_tarif_set)
          else
            move_forward(current_tarif_set)
          end
        else
          move_down(current_tarif_set)
        end
        current_tarif_set
      end
      
      def move_forward(current_tarif_set)
        part_index = current_tarif_set[:current][0] + 1
        part_set_index = 0
        set = current_tarif_set[:set] + [part_set_index]
        prev_part_set_index = current_tarif_set[:set][part_index - 1]
        sets_to_add = (current_tarif_set[:sets][part_index - 1] + indexed_tarif_set[part_index - 1][prev_part_set_index]).uniq.sort
        sets = (current_tarif_set[:sets] << sets_to_add)
        current_tarif_set = {:set => set, :current => [part_index, part_set_index], :sets => sets}      
      end
      
      def move_down(current_tarif_set)
        part_index = current_tarif_set[:current][0] 
        part_set_index = current_tarif_set[:current][1] + 1
        if indexed_tarif_set[part_index][part_set_index].blank?
          move_back(current_tarif_set)
        else
          set = current_tarif_set[:set][0..-2] + [part_set_index]
          sets = current_tarif_set[:sets]
          current_tarif_set = {:set => set, :current => [part_index, part_set_index], :sets => sets} 
        end
      end
      
      def move_back(current_tarif_set)
        part_index = current_tarif_set[:current][0] - 1
        if part_index < 0
          nil
        else
          part_set_index = current_tarif_set[:set][part_index] 
          set = current_tarif_set[:set][0..-2] 
          sets = current_tarif_set[:sets][0..-2]
          current_tarif_set = {:set => set, :current => [part_index, part_set_index], :sets => sets}
          move_down(current_tarif_set)
        end      
      end
      
      def if_tarif_set_valid(current_tarif_set)
        part_index = current_tarif_set[:current][0] 
        part_set_index = current_tarif_set[:current][1] 
        last_part_set_services = indexed_tarif_set[part_index][part_set_index]
        prev_part_sets_services = current_tarif_set[:sets][part_index]
        
        part = sorted_parts[part_index]
        available_part_services = (service_packs_by_parts[part] || [])
        prev_parts_services = part_index == 0 ? [] : parts_services[part_index -1]
        
        raise(StandardError, [part, current_tarif_set, last_part_set_services, prev_part_sets_services, available_part_services, prev_parts_services]) if 
          !last_part_set_services or !prev_part_sets_services or !available_part_services or !prev_parts_services
        raise(StandardError) if ((prev_part_sets_services & available_part_services) - last_part_set_services) == [tarif_id]
        first = (prev_part_sets_services & available_part_services) - last_part_set_services == []
        raise(StandardError) if (last_part_set_services & ((prev_parts_services - prev_part_sets_services) & available_part_services)) == [tarif_id]
        second = last_part_set_services & ((prev_parts_services - prev_part_sets_services) & available_part_services) == []
        first and second
      end
      
      def if_tarif_set_complete(current_tarif_set, parts_size)
        current_tarif_set[:set].size == parts_size
      end
      
      def tarif_set_name(current_tarif_set)
        result = []      
        current_tarif_set[:set].each_with_index do |part_set_index, part_index|
          raise(StandardError, history.join("\n\n")) if !indexed_tarif_set[part_index][part_set_index]
  #        result += (indexed_tarif_set[part_index][part_set_index] - result)
           result += indexed_tarif_set[part_index][part_set_index]
        end
        result.join("_")#.join("/")
      end  
    end  
  end
end
