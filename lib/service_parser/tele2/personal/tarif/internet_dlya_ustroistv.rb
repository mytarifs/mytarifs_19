module ServiceParser
  class Tele2
    class Personal::Tarif::InternetDlyaUstroistv < ServiceParser::Tele2
      def service_parsing_tags
        {
         :base_service_scope => ["div.my_content > div.page"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["section.b-tariff__section", "#blockHeader > section"],
             :block_name_tag => [".b-tariff__section__title", ".b-tariff__section__title_special"],
             :block_name_substitutes => {
               'стоимостьзвонков,smsиинтернетасверхвключенного' => 'Стоимость услуг сверх пакета',
             },
             
             :sub_block_tag => ["div.b-tariff__section"],
             :sub_block_name_tag => [".b-tariff__section__subtitle"],
             :sub_block_name_substitutes => {
               'принахожденииврасширенномдомашнемрегионе' => '',
               'принахождениивдомашнемрегионе' => '',
             },
             
             :row_tag => ["table > tbody > tr"],
             :param_name_tag => ['td:nth-of-type(1)', 'td:nth-of-type(1) span', "td[colspan='2'] div.b-tariff__note__summary"],
             :param_value_tag => ['td:nth-of-type(n+2)', "td[colspan='2'] div.b-tariff__note__text", 'td:first-child'],
           },
         ]
        }
      end
    end
  end
end