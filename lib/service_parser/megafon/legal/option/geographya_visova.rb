module ServiceParser
  class Megafon
    class Legal::Option::GeographyaVisova < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.b-b2b-layout__content"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.b-b2b-text"],
             :block_name_tag => ["h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > table.tariff_remote_params > tbody' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => ['> th:nth-of-type(1)', '> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > td:nth-of-type(n+2)'],
           },

           {
             :block_tag => [" > div.b-b2b-text > div.acc-section"],
             :block_name_tag => [' > div.acc-header > h3'],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table.tariff_remote_option_params > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => ['> th:nth-of-type(1)', '> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > td:nth-of-type(n+2)'],
           },
         ]
        }
      end 
    end
  end
end