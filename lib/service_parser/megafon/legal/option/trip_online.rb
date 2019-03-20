module ServiceParser
  class Megafon
    class Legal::Option::TripOnline < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.b-layout-left__wrapper", "div.p-roaming-solution", "div.d-service i-bem"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.b-roaming-prices"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > table > tbody' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Стоимость пакета интернета"},
             
             :row_tag => [" > tr:nth-of-type(n+2)"],
             :param_name_tag => ['> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => false,
             :param_value_tag => [' > td:nth-of-type(2)'],
           },
           {
             :block_tag => ["div.b-roaming-prices"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > table > tbody' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Стоимость 1 МБ интернета"},
             
             :row_tag => [" > tr:nth-of-type(n+2)"],
             :param_name_tag => ['> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => false,
             :param_value_tag => [' > td:nth-of-type(3)'],
           },
           {
             :block_tag => ["div.b-accordion_view_tariff-features"],
             :block_name_tag => [" > dl > dt.b-accordion__title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > dd div.b-text__content"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["p"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => false, 
             :param_name_tag => [],
             :param_value_tag => [],
           },
         ]
        }
      end 
    end
  end
end