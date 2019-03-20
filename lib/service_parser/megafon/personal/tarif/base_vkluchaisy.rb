module ServiceParser
  class Megafon
    class Personal::Tarif::BaseVkluchaisy < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.b-layout-left__wrapper", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.b-tariff-table-v2"],
             :block_name_tag => [" > div.b-tariff-table-v2__title > h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div.b-tariff-table-v2__container"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" div.b-tariff-table-v2__row"],
             :param_name_tag => ["div.b-tariff-table-v2__item"],
             :param_value_tag => ["span.b-tariff-table-v2__value"],
           },
           {
             :block_tag => [" > div.b-section > div.b-section__inner > div.b-section__content"],
             :block_name_tag => [" > div > dl > dt.b-accordion__title > h4"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div > dl > dd.b-accordion__content"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" div.b-tariff-table > div.b-tariff-table__row"],
             :param_name_tag => ["div.b-tariff-table__data-title"],
             :param_value_tag => ["div.b-tariff-table__data-content"],
           },
           {
             :block_tag => [" > div.b-section > div.b-section__inner > div.b-section__content > div > dl"],
             :block_name_tag => [" > dt.b-accordion__title > h4"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > dd.b-accordion__content"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" div.b-tariff-table > div.b-tariff-table__row"],
             :param_name_tag => ["div.b-tariff-table__data-title"],
             :param_value_tag => ["div.b-tariff-table__data-content"],
           },
         ]
        }
      end 
    end
  end
end