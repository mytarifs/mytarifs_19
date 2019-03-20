module ServiceParser
  class Tele2
    class Personal::Option::GovoriSpokoino < ServiceParser::Tele2
      def service_parsing_tags
        {
         :base_service_scope => ["div.page_primary"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [],
             :block_name_tag => [],
             :outside_block_name_tag => false,
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :process_sub_block => {},
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > ul > li"],
             :return_row_item_text => true,
             :row_item_text_to_split_by_regex => {
               /^(Абонентская плата)\s(.*)$/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => [],
             :block_name_tag => [],
             :outside_block_name_tag => false,
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :process_sub_block => {},
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p"],
             :return_row_item_text => true,
             :row_item_text_to_split_by_regex => {
               /^(.*)[-|–|-|—](.*)$/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
         ]
        }
      end
    end
  end
end