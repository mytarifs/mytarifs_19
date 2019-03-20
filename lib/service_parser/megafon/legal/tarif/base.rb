module ServiceParser
  class Megafon
    class Legal::Tarif::Base < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.p-b2btariff-matrix-one div.b-b2b-layout__content", "div.d-tariff-remote div.b-b2b-layout__content"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["> div.b-b2b-text"],
#             :outside_block_name_tag => true,
#             :block_name_tag => ["title"],
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["table > tbody > tr"],
             :param_name_tag => ['td:nth-of-type(1)',],
             :param_value_tag => ['td:nth-of-type(n+2)',],
           },
           {
             :block_tag => ["div.b-b2b-tariff-card > div.b-b2b-tariff-card__inner"],
             :block_name_tag => [" > tariff"],
             :block_name_attributes_to_text => ['title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["p.b-b2b-tariff-card__line"],
             :param_name_tag => ['.b-b2b-tariff-card__name',],
             :param_value_tag => ['.b-b2b-tariff-card__price-original',],
           },
         ]
        }
      end
    end
  end
end