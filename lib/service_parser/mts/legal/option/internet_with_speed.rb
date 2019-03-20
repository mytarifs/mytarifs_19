module ServiceParser
  class Mts
    class Legal::Option::InternetWithSpeed < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > table.common"],
             :process_block => {:transponse_table => []},
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > tbody"],
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