module Optimization
  class BaseTarifSetChecker
    attr_reader :tarif_list_generator, :tarif_sets, :indexed_tarif_set, :history, :service_packs_by_parts, :current_parts, :parts_to_exclude, :parts_services
    attr_reader :if_save_history
    
    def initialize(options)
      @tarif_list_generator = options[:tarif_list_generator]
      @parts_to_exclude = options[:parts_to_exclude] || ['periodic', 'onetime']
      init_service_packs_by_parts(options[:service_packs_by_parts])
      init_tarif_sets(options[:tarif_sets])
      init_indexed_tarif_set(options[:indexed_tarif_set])
      init_parts_services(options[:parts_services])
      @history = {}
      @if_save_history = options[:if_save_history] || false
    end
    
    def init_tarif_sets(tarif_sets = {})
      return @tarif_sets if @tarif_sets
      return @tarif_sets = tarif_sets if !tarif_sets.blank?
      tarif_list_generator.calculate_tarif_sets_and_slices if tarif_list_generator.tarif_sets.blank?
      @tarif_sets = tarif_list_generator.tarif_sets
    end
    
    def init_service_packs_by_parts(service_packs_by_parts = {})
      return @service_packs_by_parts if @service_packs_by_parts
      return @service_packs_by_parts = service_packs_by_parts if !service_packs_by_parts.blank?
      @service_packs_by_parts = tarif_list_generator.service_packs_by_parts
    end
    
    def set_frequency_by_parts(tarif)
      sorted_parts(tarif).map{|p| (tarif_sets[tarif][p].keys || []).size }
    end
    
    def sorted_parts(tarif)
      return @sorted_parts[tarif] if @sorted_parts and @sorted_parts[tarif]
      @sorted_parts ||= {}
      @sorted_parts[tarif] = (tarif_sets[tarif].keys - parts_to_exclude).sort_by{|p| (tarif_sets[tarif][p].keys || []).size}
    end
    
    def init_indexed_tarif_set(indexed_tarif_set = {})
      return @indexed_tarif_set if @indexed_tarif_set
      return @indexed_tarif_set = indexed_tarif_set if !indexed_tarif_set.blank?
      @indexed_tarif_set = {}
      tarif_sets.each do |tarif, tarif_sets_by_parts|
        @indexed_tarif_set[tarif] ||= []
        sorted_parts(tarif).each_with_index do |part, part_index|
          @indexed_tarif_set[tarif][part_index] ||= []
          tarif_sets_by_parts[part].keys.each_with_index do |part_set, part_set_index|
            @indexed_tarif_set[tarif][part_index][part_set_index] = tarif_sets_by_parts[part][part_set]
          end
        end
      end
    end
    
    def init_parts_services(parts_services = {})
      return @parts_services if @parts_services
      return @parts_services = parts_services if !parts_services.blank?
      @parts_services = {}
      tarif_sets.each do |tarif, tarif_sets_by_parts|
        @parts_services[tarif] ||= {}
        sorted_parts(tarif).each_with_index do |part, part_index|
          @parts_services[tarif][part_index] = part_index.times.map{|p| service_packs_by_parts[tarif][sorted_parts(tarif)[p]]}.flatten.uniq
        end
      end
    end
    
    def generate_all_tarif_sets
      result = {}; i = 0; j = 0
      j_max = 30000000000        
      print_period = 100000
      
      iterate do |tarif, tarif_sets_by_parts, current_tarif_set, if_valid, if_complete|
        if if_save_history
          history[tarif] ||= []
          history[tarif] << current_tarif_set 
        end
  #        result[tarif] ||= []        
        result[tarif] ||= 0        
  
        if if_valid and if_complete
  #          result[tarif] << tarif_set_name(tarif, current_tarif_set)
          result[tarif] += 1
          i += 1
        end           
        puts "#{[tarif, j, set_frequency_by_parts(tarif), current_tarif_set.slice(:set, :current)]}" if (j - (j/print_period) * print_period) == 0
        break if j > j_max
        j += 1
      end
      [result, i, j]
    end
  
    def iterate
      tarif_sets.each do |tarif, tarif_sets_by_parts|
        @current_parts = sorted_parts(tarif)
        current_tarif_set = {:set => [0], :current => [0,0], :sets => [[]]}
        while current_tarif_set
          if_valid = if_tarif_set_valid(tarif, current_tarif_set)
          if_complete = if_tarif_set_complete(current_tarif_set, current_parts.size)
          yield [tarif, tarif_sets_by_parts, current_tarif_set, if_valid, if_complete]
          current_tarif_set = next_part_set(tarif, current_tarif_set, if_valid, if_complete)
        end
      end
    end
    
    def next_part_set(tarif, current_tarif_set, if_valid, if_complete)
      current_tarif_set = if if_valid
        if if_complete
          move_down(tarif, current_tarif_set)
        else
          move_forward(tarif, current_tarif_set)
        end
      else
        move_down(tarif, current_tarif_set)
      end
      history[tarif] << current_tarif_set  if if_save_history
      current_tarif_set
    end
    
    def move_forward(tarif, current_tarif_set)
      part_index = current_tarif_set[:current][0] + 1
      part_set_index = 0
      set = current_tarif_set[:set] + [part_set_index]
      prev_part_set_index = current_tarif_set[:set][part_index - 1]
      sets_to_add = (current_tarif_set[:sets][part_index - 1] + indexed_tarif_set[tarif][part_index - 1][prev_part_set_index]).uniq.sort
      sets = (current_tarif_set[:sets] << sets_to_add)
      current_tarif_set = {:set => set, :current => [part_index, part_set_index], :sets => sets}      
    end
    
    def move_down(tarif, current_tarif_set)
      part_index = current_tarif_set[:current][0] 
      part_set_index = current_tarif_set[:current][1] + 1
      if indexed_tarif_set[tarif][part_index][part_set_index].blank?
        move_back(tarif, current_tarif_set)
      else
        set = current_tarif_set[:set][0..-2] + [part_set_index]
        sets = current_tarif_set[:sets]
        current_tarif_set = {:set => set, :current => [part_index, part_set_index], :sets => sets} 
      end
    end
    
    def move_back(tarif, current_tarif_set)
      part_index = current_tarif_set[:current][0] - 1
      if part_index < 0
        nil
      else
        part_set_index = current_tarif_set[:set][part_index] 
        set = current_tarif_set[:set][0..-2] 
        sets = current_tarif_set[:sets][0..-2]
        current_tarif_set = {:set => set, :current => [part_index, part_set_index], :sets => sets}
        move_down(tarif, current_tarif_set)
      end      
    end
    
    def if_tarif_set_valid(tarif, current_tarif_set)
      part_index = current_tarif_set[:current][0] 
      part_set_index = current_tarif_set[:current][1] 
      last_part_set_services = indexed_tarif_set[tarif][part_index][part_set_index]
      prev_part_sets_services = current_tarif_set[:sets][part_index]
      
      part = current_parts[part_index]
      available_part_services = (service_packs_by_parts[tarif][part] || [])
      prev_parts_services = part_index == 0 ? [] : parts_services[tarif][part_index -1]
      
      raise(StandardError, [tarif, part, current_tarif_set, last_part_set_services, prev_part_sets_services, available_part_services, prev_parts_services]) if 
        !last_part_set_services or !prev_part_sets_services or !available_part_services or !prev_parts_services
      raise(StandardError) if ((prev_part_sets_services & available_part_services) - last_part_set_services) == [tarif]
      first = (prev_part_sets_services & available_part_services) - last_part_set_services == []
      raise(StandardError) if (last_part_set_services & ((prev_parts_services - prev_part_sets_services) & available_part_services)) == [tarif]
      second = last_part_set_services & ((prev_parts_services - prev_part_sets_services) & available_part_services) == []
      first and second
    end
    
    def if_tarif_set_complete(current_tarif_set, parts_size)
      current_tarif_set[:set].size == parts_size
    end
    
    def tarif_set_name(tarif, current_tarif_set)
      result = []      
      current_tarif_set[:set].each_with_index do |part_set_index, part_index|
        raise(StandardError, history[tarif].join("\n\n")) if !indexed_tarif_set[tarif][part_index][part_set_index]
        result += (indexed_tarif_set[tarif][part_index][part_set_index] - result)
  #        result << indexed_tarif_set[tarif][part_index][part_set_index].join("_")
      end
      result#.join("/")
    end
  end
end