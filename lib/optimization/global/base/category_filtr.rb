module Optimization::Global
  class Base  
    class CategoryFiltr
      attr_reader :f
    
      def initialize(options = {})
        @f = CallFields.new
      end
  
      def test
        category_filtr = Service::CategoryTarifClass.where.not(:filtr => nil).first.filtr
        filtr(category_filtr)
      end
      
      def filtr_for_stat(stat_item, category_filtr, m_region_id, operator_id)
        result = true
        
        category_filtr.each do |global_category, filtr_desc|
          comparison = filtr_desc["in"] ? 'in' : 'not_in'
          
          filtr_desc_to_use = substitute_filtr_desc_with_special_negative_values(filtr_desc[comparison], m_region_id, operator_id)
          raise(StandardError) if global_category == 'own_and_home_regions' and false
          
          result = filtr_desc_to_use.blank? ? true : 
            (global_category == 'to_chosen_numbers' ? false : filtr_desc_to_use.include?(stat_item[send(global_category.to_sym)]) )
          
          result = !result if comparison == 'not_in'
  
          return result if !result
        end
        result
      end
      
      #Seems to be unused
      def filtr(category_filtr, m_region_id, operator_id)
        filtr_where_hash = ["true"]
        category_filtr.each do |global_category, filtr_desc|
          filtr_where_hash << if filtr_desc["in"]
            filtr_desc_to_use = substitute_filtr_desc_with_special_negative_values(filtr_desc["in"], m_region_id, operator_id)
            filtr_desc_to_use.blank? ? "true" : 
              (global_category == 'to_chosen_numbers' ? "false" : "(#{send(global_category.to_sym)} = any('{#{filtr_desc_to_use.join(', ')}}'))" )
          else
            filtr_desc_to_use = substitute_filtr_desc_with_special_negative_values(filtr_desc["not_in"], m_region_id, operator_id)
            if filtr_desc_to_use
              filtr_desc_to_use.blank? ? "true" :  
                (global_category == 'to_chosen_numbers' ? "true" : "(#{send(global_category.to_sym)} != all('{#{filtr_desc_to_use.join(', ')}}'))" )
            else
              raise(StandardError, [category_filtr, filtr_desc, !filtr_desc["in"].blank?, !filtr_desc["not_in"].blank?])
            end          
          end
        end
        filtr_where_hash.join(" and ")
      end
      
      def substitute_filtr_desc_with_special_negative_values(filtr_desc, m_region_id, operator_id)
        return filtr_desc if filtr_desc.blank?

        negative_filtr_desc_items = filtr_desc.select{|filtr_desc_item| filtr_desc_item < 0 }
        return filtr_desc if negative_filtr_desc_items.blank?
        
        subsitute_values_for_negative = []
        negative_filtr_desc_items.each do |negative_filtr_desc_item|
          subsitute_values_for_negative += Category::Region::Desc.new(m_region_id, operator_id).region_ids_by_region_type(negative_filtr_desc_item)          
        end
        
        filtr_desc - negative_filtr_desc_items + subsitute_values_for_negative
      end
  
      #Seems to be unused
      def row_filtr(row, category_filtr)
        result = true
        category_filtr.each do |global_category, filtr_desc|
          temp_result = case
          when filtr_desc["in"]
            filtr_desc["in"].blank? ? true : filtr_desc["in"].include?(row[send(global_category.to_sym)])
          when filtr_desc["not_in"]
            filtr_desc["not_in"].blank? ? true : !filtr_desc["not_in"].include?(row[send(global_category.to_sym)])
          else
            raise(StandardError, [category_filtr, filtr_desc, !filtr_desc["in"].blank?, !filtr_desc["not_in"].blank?])
          end
          return false if !temp_result
        end
        result
      end
      
      def russia; "connect_country_id"; end
      def abroad_countries; "connect_country_id"; end
  
      def own_region; "connect_region_id"; end
      def home_regions; "connect_region_id"; end
      def own_and_home_regions; "connect_region_id"; end
      def own_country_regions; "connect_region_id"; end
  #    def any_region; "true"; end
  
  #    def calls_in; "#{f.base_service_id} = #{::Category::BaseService::Call} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Inbound}"; end
  #    def calls_out; "#{f.base_service_id} = #{::Category::BaseService::Call} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Outbound}"; end
  #    def sms_in; "#{f.base_service_id} = #{::Category::BaseService::Sms} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Inbound}"; end
  #    def sms_out; "#{f.base_service_id} = #{::Category::BaseService::Sms} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Outbound}"; end
  #    def mms_in; "#{f.base_service_id} = #{::Category::BaseService::Mms} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Inbound}"; end
  #    def mms_out; "#{f.base_service_id} = #{::Category::BaseService::Mms} and #{f.base_subservice_id} = #{::Category::ServiceDirection::Outbound}"; end
  #    def internet; "#{f.base_service_id} = any('{#{::Category::BaseService::Internet.join(', ')}}')"; end
  
      def to_own_region; "partner_region_id"; end
      def to_home_regions; "partner_region_id"; end
      def to_own_and_home_regions; "partner_region_id"; end
      def to_own_country_regions; "partner_region_id"; end
#      def to_abroad; "partner_country_id"; end
      def to_abroad_countries; "partner_country_id"; end
      def to_russia; "partner_country_id"; end
      def to_rouming_country; "partner_country_id"; end
      def to_other_countries; "partner_country_id"; end
  #    def from_any_location; "true"; end
  
      def to_operators; "partner_operator_id"; end
      def from_operators; "partner_operator_id"; end
  #    def to_fix_line; "#{f.partner_operator_type_id} = #{::Category::OperatorType::Fixed_line}"; end
  
    end
  end  
end
