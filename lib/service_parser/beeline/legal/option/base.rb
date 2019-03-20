module ServiceParser
  class Beeline
    class Legal::Option::Base < ServiceParser::Beeline
      def service_parsing_tags
        {
         :base_service_scope => ["div.content-block"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["tbody:contains('#{tarif_class.name}') + tbody:nth-of-type(1) div.sub-table"],
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table > tbody > tr"],
             :return_ony_own_sub_block_text => true,
             :sub_block_name_tag => ['td:nth-of-type(1)',],
             :sub_block_name_substitutes => {},
             
             :row_tag => [],
             :return_ony_own_param_name_text => true,
             :param_name_tag => [],
             :param_value_tag => ['td:nth-of-type(n+2)',],
           },
           {
             :block_tag => ["tbody:contains('#{tarif_class.name}') + tbody:nth-of-type(1) div.sub-table"],
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table > tbody > tr"],
             :return_ony_own_sub_block_text => true,
             :sub_block_name_tag => ['td:nth-of-type(1) > div',],
             :sub_block_name_substitutes => {},
             
             :row_tag => [],
             :return_ony_own_param_name_text => false,
             :param_name_tag => ["td:nth-of-type(1) > div > div"],
             :param_value_tag => ['td:nth-of-type(n+2)',],
           },
           {
             :block_tag => ["#paramGroups"],
             :block_name_tag => ["h4"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div > table > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => ['td:nth-of-type(1)',],
             :param_value_tag => ['td:nth-of-type(n+2)',],
           },
         ]
        }
      end
    end
  end
end