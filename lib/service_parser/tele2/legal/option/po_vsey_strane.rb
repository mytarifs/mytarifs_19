module ServiceParser
  class Tele2
    class Legal::Option::PoVseyStrane < ServiceParser::Tele2
      def service_parsing_tags
        {
         :base_service_scope => ["div.page_primary"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div > div.tbl-wrap"],
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > table"],
             :process_sub_block => {:transponse_table => []},
             :sub_block_name_tag => [' > tbody > tr:nth-child(1) > td'],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tbody > tr"],
             :return_row_item_text => false,
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
         ]
        }
      end
    end
  end
end