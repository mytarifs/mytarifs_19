module ServiceParser
  class Megafon
    class Legal::Option::AddSpeed < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.d-tariff-remote-option"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.b-b2b-text"],
             :block_name_tag => [" > h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > table.tariff_remote_params > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > td:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(2)"],
           },
           {
             :block_tag => ["div.b-b2b-text > div.acc-section"],
             :block_name_tag => [" > div.acc-header > h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div > table.tariff_remote_option_params > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > td:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(2)"],
           },
         ]
        }
      end 
    end
  end
end