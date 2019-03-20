module ServiceParser
  class Tele2
    class Legal::Common::Base < ServiceParser::Tele2
      def service_parsing_tags
        {
         :base_service_scope => ["div.page"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["section.b-tariff__section"],
             :block_name_tag => [".b-tariff__section__title"],
             :block_name_substitutes => {
               'стоимостьзвонков,smsиинтернетасверхвключенного' => 'Стоимость услуг сверх пакета',
             },
             
             :sub_block_tag => ["div.b-tariff__section"],
             :sub_block_name_tag => [".b-tariff__section__subtitle"],
             :sub_block_name_substitutes => {},
             
             :row_tag => [".b-tariff__param"],
             :param_name_tag => ['dt.b-tariff__param__title'],
             :param_value_tag => ['dd.b-tariff__param__value'],
           },
           {
             :block_tag => ["section.b-tariff__section"],
             :block_name_tag => [".b-tariff__section__title"],
             :block_name_substitutes => {
             },
             
             :sub_block_tag => [" > div.b-tariff__note"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ['> div.b-tariff__note__summary'],
             :return_row_item_text => true,
             :row_item_text_to_split_by_regex => {
               /^(.*)$/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => ["section.b-tariff__section"],
             :block_name_tag => [".b-tariff__section__title"],
             :block_name_substitutes => {
             },
             
             :sub_block_tag => [" > div.b-tariff__section__content > div.b-tariff__note"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ['> div.b-tariff__note__summary'],
             :return_row_item_text => true,
             :row_item_text_to_split_by_regex => {
               /^(.*зону соседние регионы.*входят:)(.*)$/i => [1..1, 2..2], 
               /^(.*)$/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           }
         ]
        }
      end
    end
  end
end