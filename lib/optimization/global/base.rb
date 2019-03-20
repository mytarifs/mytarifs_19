module Optimization::Global
  class Base
    attr_reader :f, :call_filtr, :call_group, :category_filtr, :structure_name
    
    def initialize(options = {})
      @f = CallFields.new
      @call_filtr = CallFiltr.new(options)
      @call_group = CallGroup.new
      @category_filtr = CategoryFiltr.new
      @structure_name = StructureName.new
    end
    
    def items
      result = []
      iterate do |rouming_country, rouming_region, service, destination, partner, final_category|
        result << [rouming_country, rouming_region, service, destination, partner]
      end
      result
    end
    
    def iterate_with_index
      index = 0
      iterate do |rouming_country, rouming_region, service, destination, partner, final_category|
        yield [index, rouming_country, rouming_region, service, destination, partner]
        index += 1
      end
    end
    
    def iterate(structure_constant = Structure)
      structure_constant.each do |rouming_country, cat_by_rouming_country|
        cat_by_rouming_country.each do |rouming_region, cat_by_rouming_region|
          if cat_by_rouming_region.blank?
            yield [rouming_country, rouming_region, nil, nil, nil, cat_by_rouming_region]
          else
            cat_by_rouming_region.each do |service, cat_by_service|          
              if cat_by_service.blank?
                yield [rouming_country, rouming_region, service, nil, nil, cat_by_service]
              else
                cat_by_service.each do |destination, cat_by_destination|
                  if cat_by_destination.blank?
                    yield [rouming_country, rouming_region, service, destination, nil, cat_by_destination]
                  else
                    cat_by_destination.each do |partner, cat_by_partner|
                      yield [rouming_country, rouming_region, service, destination, partner, cat_by_partner]
                    end                
                  end
                end
              end
            end        
          end
        end      
      end
    end
  
    def filtr_from_global_category_names(global_category_names_by_parts)
      return 'true' if global_category_names_by_parts.blank? 
      global_category_names = global_category_names_by_parts.values.flatten
      global_categories = global_category_names.map{|global_category_name| params_from_global_name(global_category_name)}
      global_categories.map{|global_category| "(#{call_filtr.filtr(global_category)})"}.join(" or ")
    end
    
    def global_names_by_parts(parts)
      result = {}
      parts.each do |part|
        result[part] ||= []
        result[part] += global_names_by_part(part)[part]
      end
      result
    end
    
    def parts_from_global_categories(global_categories)
      parts = []
      global_categories.each do |global_category|
        parts += [Optimization::Global::Base::StructureByPartsHelper.part_from_uniq_service_category(global_category)] - parts
      end
      parts
    end
    
    #Optimization::Global::Base.new.global_names_by_part(StructureByParts['own-country-rouming/calls'])
    def global_names_by_part(part)
      result = {}
      iterate(::Optimization::Global::Base::StructureByParts[part]) do |rouming_country, rouming_region, service, destination, partner, final_category|
        params = [rouming_country, rouming_region, service, destination, partner, final_category].compact - [{}]
        result[part] ||= []
        result[part] << global_name(params)
      end
      result
    end
    
    def global_name(params)
      structure_name.name(params)
    end
    
    def params_from_global_name(global_name)
      structure_name.params_from_name(global_name)
    end  
  end    
end
