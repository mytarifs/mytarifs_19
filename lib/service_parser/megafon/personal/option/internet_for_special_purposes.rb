module ServiceParser
  class Megafon
    class Personal::Option::InternetForSpecialPurposes < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.b-layout-left__wrapper", "div.p-roaming-solution"],
         :additional_service_scope => [],
         :service_blocks => [
# for use with div.p-roaming-solution
           {
             :block_tag => ["div.b-roaming-prices"],
             :block_name_tag => [' > table > tbody > tr:first-of-type > th:nth-of-type(1)'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > table > tbody' ],
             :sub_block_name_tag => [" > tr:first-of-type > th:nth-of-type(2)"],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr:nth-of-type(n+2)"],
             :param_name_tag => ['> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > td:nth-of-type(2)'],
           },
           {
             :block_tag => ["div.b-roaming-prices"],
             :block_name_tag => [' > table > tbody > tr:first-of-type > th:nth-of-type(1)'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > table > tbody' ],
             :sub_block_name_tag => [" > tr:first-of-type > th:nth-of-type(3)"],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr:nth-of-type(n+2)"],
             :param_name_tag => ['> td:nth-of-type(1)'],
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