module Optimization::Global
  class Base
    module CategoryHelper
      def self.category_ids_from_filtr(filtr)
        result = {:geo => [], :rouming => [], :operators => []}
        
        ['own_and_home_regions', 'own_country_regions', 'abroad_countries'].each do |rouming_key|
          result[:rouming] += (filtr.try(:[], rouming_key).try(:[], 'in') || [])
          result[:rouming] += (filtr.try(:[], rouming_key).try(:[], 'not_in') || [])
        end
    
        ['to_own_and_home_regions', 'to_own_country_regions', 'to_abroad_countries', 'to_other_countries'].each do |geo_key| #, 'to_abroad'
          result[:geo] += (filtr.try(:[], geo_key).try(:[], 'in') || [])
          result[:geo] += (filtr.try(:[], geo_key).try(:[], 'not_in') || [])
        end

        ['to_operators'].each do |operator_key|
          result[:operators] += (filtr.try(:[], operator_key).try(:[], 'in') || [])
          result[:operators] += (filtr.try(:[], operator_key).try(:[], 'not_in') || [])
        end
        
        result
      end
      
      def self.global_categories_from_uniq_category(service_category_attributes)
        sc = service_category_attributes
        
        global_categories = (sc["uniq_service_category"] || "").split("/")
        raise(StandardError, [
          sc
        ]) if false
        [0, 1, 2].each do |index|
          if global_categories[index] and sc["filtr"].try(:[], global_categories[index]).try(:[], "name")
            global_categories[index] = sc["filtr"].try(:[], global_categories[index]).try(:[], "name")
          end
        end
                
        if global_categories[2] == 'to_operators'
          global_categories[3] = global_categories[2]
          global_categories[2] = nil
        end
        
        if !global_categories.blank? and global_categories[2].nil? and global_categories[1] != "internet" 
          global_categories[2] = if sc["filtr"].try(:[], "to_abroad_countries").try(:[], "name")
            sc["filtr"].try(:[], "to_abroad_countries").try(:[], "name")
          else
            'to_russia' 
          end
        end
        
        global_categories[3] = if !sc["filtr"].try(:[], 'to_operators').blank? #global_categories[3] and 
          if sc["filtr"]['to_operators']['in']
            ["in", sc["filtr"]['to_operators']['in']]
          else
            ["not_in", sc["filtr"]['to_operators']['not_in']]
          end
        else
          nil
        end

        global_categories[4] = if !sc["filtr"].try(:[], 'to_chosen_numbers').blank? #global_categories[3] and 
          if sc["filtr"]['to_chosen_numbers']['in']
            ["in", sc["filtr"]['to_chosen_numbers']['in'], 'to_chosen_numbers']
          else
            ["not_in", sc["filtr"]['to_chosen_numbers']['not_in'], 'to_chosen_numbers']
          end
        else
          nil
        end
        
        global_categories[4] = if !sc["filtr"].try(:[], 'internet').blank? #global_categories[3] and 
          if sc["filtr"]['internet']['in']
            ["in", sc["filtr"]['internet']['in'], 'internet']
          else
            ["not_in", sc["filtr"]['internet']['not_in'], 'internet']
          end
        else
          global_categories[4]
        end
        
        global_categories
      end
    end
  end
end
