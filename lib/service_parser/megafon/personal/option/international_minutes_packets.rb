module ServiceParser
  class Megafon
    class Personal::Option::InternationalMinutesPackets < ServiceParser::Megafon
      def service_parsing_tags
        minutes_volume = tarif_class.name.match(/^Пакеты минут (\d+)\s(.*)/i)[1]
        {
         :base_service_scope => ["div.p-roaming-solution"], #"div.b-layout-left__wrapper", 
         :additional_service_scope => [],
         :service_blocks => [
# for use with div.p-roaming-solution
           {
             :block_tag => ["div.b-roaming-prices table"],
             :process_block => {
#               :add_header_to_column_in_table => [],
               :repaire_table => [],
               :select_only_first_column_and_column_with_chosen_head => ["#{minutes_volume} минут"],
             },
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > tbody' ],
             :sub_block_name_tag => [" > tr:first-of-type > th:nth-of-type(2)"],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr:nth-of-type(n+2)"],
             :param_name_tag => ['> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > td:nth-of-type(2)'],
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