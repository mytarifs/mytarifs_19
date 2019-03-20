module ServiceParser
  class Mts
    class Legal::Option::AddTrafic < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["#mainForm"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.tarffs_block_v2"],
             :block_name_tag => ["table.smart_tariff__options div.quota_tarffs_block"],
             
             :sub_block_tag => ["div.play_tariff__smart"],
             :return_ony_own_sub_block_text => true,
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Абонентская плата"},
             
             :row_tag => [],
             :param_name_tag => [],
             :param_value_tag => [" > div.price"],
           },
           {
             :block_tag => ["div.slider-smooth:contains('Турбо-кнопка 20 ГБ')"],
             :block_name_tag => ["h3"],
             
             :sub_block_tag => ["table.characteristics_smart_tariff > tbody > tr:contains('Оплата')"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Абонентская плата"},
             
             :row_tag => [" > td.text_smart_options > p"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true,
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /(стоимость.*)[:|–|-]\s(.*)/i => [1..1, 2..2],
             },
             :param_name_tag => [],
             :param_value_tag => [" > div.price"],
           }
         ]
        }
      end
    end
  end
end