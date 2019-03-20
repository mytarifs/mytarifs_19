module ServiceParser
  class Megafon
    class Legal::Option::InternetOnRussia < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.p-roaming-solution"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.b-roaming-prices"],
             :block_name_tag => [" > h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > table.b-roaming-prices__table:contains('Для пользователей опци') > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "для остальных"},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > td:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(3)"],
           },
           {
             :block_tag => ["div.b-roaming-prices"],
             :block_name_tag => [" > h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > table.b-roaming-prices__table:contains('Для пользователей опци') > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "для XS"},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > td:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(2)"],
           },

           {
             :block_tag => ["div.b-roaming-prices > table.b-roaming-prices__table:contains('Интернет XS')"],
             :process_block => {
              :repaire_table => [],
              :transponse_table => [],
             },
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "для остальных"},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > th:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(2)"],
           },
           {
             :block_tag => ["div.b-roaming-prices > table.b-roaming-prices__table:contains('Интернет XS')"],
             :process_block => {
              :repaire_table => [],
              :transponse_table => [],
             },
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "для XS"},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > th:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(1)"],
           },

           {
             :block_tag => ["div.b-roaming-prices > table.b-roaming-prices__table:contains('c тарифными планами')"],
             :process_block => {
              :repaire_table => [],
             },
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "ежедневная оплата"},
             
             :row_tag => [" > tr:nth-of-type(-n+4)"],
             :param_name_tag => [" > td:nth-of-type(1)"],
#             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [" > td:nth-of-type(3)"],
           },
           {
             :block_tag => ["div.b-roaming-prices > table.b-roaming-prices__table:contains('c тарифными планами')"],
             :process_block => {
              :repaire_table => [],
             },
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Подключение тарифной опции"},
             
             :row_tag => [" > tr:nth-of-type(6)"],
             :param_name_tag => [" > td:nth-of-type(1)"],
#             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [" > td:nth-of-type(3)"],
           },

           {
             :block_tag => ["div.b-roaming-prices > h2:contains('Стоимость услуг') + table.b-roaming-prices__table"],
             :process_block => {
              :repaire_table => [],
             },
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr:nth-of-type(n)"],
             :param_name_tag => [" > td:nth-of-type(1)"],
#             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [" > td:nth-of-type(3)"],
           },
#additional info
           {
             :block_tag => ["div.b-accordion_view_tariff-features"],
             :block_name_tag => [" > dl > dt.b-accordion__title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > dd"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["ul > li"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
             :param_name_tag => [],
             :param_value_tag => [],
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