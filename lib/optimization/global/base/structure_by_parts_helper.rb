module Optimization::Global
  class Base
    module StructureByPartsHelper
    
      def self.part_from_service_category_tarif_class(service_category_tarif_class_attributes)
        case 
        when service_category_tarif_class_attributes['service_category_one_time_id']
          'onetime'
        when service_category_tarif_class_attributes['service_category_periodic_id']
          'periodic'
        when service_category_tarif_class_attributes['uniq_service_category']
          part_from_uniq_service_category(service_category_tarif_class_attributes['uniq_service_category'])
        else
          raise(StandardError, [service_category_tarif_class_attributes])
        end    
      end
    
      def self.part_from_uniq_service_category(uniq_service_category)
        part = []
        categories = uniq_service_category.split("/")
        part << (['own_and_home_regions', 'own_country_regions'].include?(categories[0]) ? 'own-country-rouming' : 'all-world-rouming')
        
        part << case
        when ['calls_in', 'calls_out'].include?(categories[1])
          'calls'
        when ['sms_in', 'sms_out'].include?(categories[1])
          'sms'
        when ['mms_in', 'mms_out'].include?(categories[1])
          'mms'
        when ['internet'].include?(categories[1])
          'mobile-connection'
        else
          raise(StandardError, [part, uniq_service_category])
        end
        raise(StandardError, [
          part
        ]) if false
        part.join('/')
      end
    


    end
  end
end
