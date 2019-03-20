module ServiceParser
  class Megafon
    class Personal::Option::TravelWithoutWorry < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => [ "div.p-roaming-solution"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.b-roaming-prices > table"],
             :process_block => {
               :repaire_table => [],
#               :add_header_to_column_in_table => [],
#               :select_only_first_column_and_column_with_chosen_head => ["Повторное"],
             },
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "2-й столбец"},
             
             :sub_block_tag => [' > tbody' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => ['> th:nth-of-type(1)', '> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > td:nth-of-type(2)'],
           },
           {
             :block_tag => ["div.b-roaming-prices > table"],
             :process_block => {
               :repaire_table => [],
#               :add_header_to_column_in_table => [],
#               :select_only_first_column_and_column_with_chosen_head => ["Повторное"],
             },
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "3-й столбец"},
             
             :sub_block_tag => [' > tbody' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => ['> th:nth-of-type(1)', '> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > td:nth-of-type(3)'],
           },
           {
             :block_tag => ["dl.b-spoiler"],
             :block_name_tag => [' > dt.b-spoiler__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > dd.b-spoiler__content' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
           },
           {
             :block_tag => ["dl.b-spoiler"],
             :block_name_tag => [' > dt.b-spoiler__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > dd.b-spoiler__content' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > ul > li"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
           },
#####          
         ]
        }
      end 
    end
  end
end