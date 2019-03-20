module ServiceParser
  class Mts
    class Legal::Option::Gb100Day < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["table.characteristics_smart_tariff"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Стоимость подключения"},
             
             :sub_block_tag => [" > tbody > tr"],
             :sub_block_name_tag => [" > td:nth-child(1)"],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > td:nth-child(2) > p", " > td:nth-child(2)"],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true,
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /(?=.*(Плата за подключение опции.*?))(?=.*?(\d+\s?\d*[\.|\,]?\d*?\s+)).*\1.*\2.*/i => [1..1, 2..2], 
               /(.*?[.]?)(.*)/i => [1..1, 1..2]
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => ["div.content_slider_smart"],
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p", " > ul > li"],
             :return_row_item_text => true,
             :param_name_tag => [],
             :param_value_tag => [],
           },
         ]
        }
      end
    end
  end
end