module ServiceParser
  class Megafon
    class Personal::Tarif::Base < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.b-layout-left__wrapper", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["> div.b-tariff-description"],
             :block_name_tag => ["h1"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [],
             :param_name_tag => [],
             :param_value_tag => ['h3',],
           },
           {
             :block_tag => ["> div.b-tariff-table"],
             :block_name_tag => ['div.b-text__content.b-tariff-features'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.b-tariff-table__row"],
             :param_name_tag => ['div.b-tariff-table__data-title',],
             :param_value_tag => ['div.b-tariff-table__data-content',],
           },
           {
             :block_tag => ["> div.b-accordion_view_tariff"],
             :block_name_tag => ['dt.b-accordion__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => ['dd.b-accordion__content div' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.b-tariff-table__row"],
             :param_name_tag => ['div.b-tariff-table__data-title'],
             :param_value_tag => ['div.b-tariff-table__data-content'],
           },
           {
             :block_tag => ["> div.b-accordion_view_tariff-features"],
             :block_name_tag => ['dt.b-accordion__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => ['dd.b-accordion__content div' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.b-tariff-features__content"],
             :param_name_tag => ['p:nth-of-type(1)'],
             :param_value_tag => ['p:nth-of-type(n+2)'],
           },
         ]
        }
      end 
    end
  end
end