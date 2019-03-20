module ServiceParser
  class Mts
    class Personal::Option::InternetNaDen < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["table.characteristics_smart_tariff", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > tbody > tr"],
             :block_name_tag => [" > td:first-child"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > td:nth-of-type(n+1)"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true,
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /^(Плата за подключение.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /^(Плата за опцию списывается только в дни пользования.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2],
               /(.*Базовая квота.*?)(\d+\s?[м|г]б).*/i => [1..1, 2..2],
               /(.*Опция «Интернет на день» действует)(.*)/i => [1..1, 2..2],
               /(.*)[:|-]\s(.*)/i => [1..1, 2..2],
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