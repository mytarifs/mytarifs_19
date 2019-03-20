module ServiceParser
  class Mts
    class Personal::Tarif::Transformische < ServiceParser::Mts::Personal::Tarif::Base
      def service_parsing_tags
        {
         :base_service_scope => ["div.footer__to-bottom-content", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.product-info__info-wrap"],
             :block_name_tag => ["div.product-info_transformishe__name"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div.product-info_transformishe__filter"],
             :return_ony_own_sub_block_text => true,
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"no_sub_block" => "Пакеты минут - объем"},
             
             :row_tag => ["div.select-bar__text"],
             :return_row_item_text => true,
             :sub_block_text_to_split_by_regex => {
               /(?=.*(\d+))(?=(.*)).*\1.*/i => [2..2, 1..1],                
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => ["section.product-adv"],
             :block_name_tag => ["section.product-more-layout h2.section-box__title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["div.product-params__row"],
             :outside_sub_block_name_tag => false,
             :sub_block_name_tag => ["div.product-params__title"],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.product-params__info"],
             :param_name_tag => [" > div.product-params__info-label > span"],
             :param_value_tag => [" > div.product-params__info-value > span"],
           },
           {
             :block_tag => ["section.product-adv"],
             :block_name_tag => ["section.product-more-layout h2.section-box__title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["div.product-params__row"],
             :outside_sub_block_name_tag => false,
             :sub_block_name_tag => ["div.product-params__title"],
             :sub_block_name_substitutes => {"вплатупотарифувключено" => "В плату по тарифу включено 1"},
             
             :row_tag => ["div.product-params__info > div.product-params__info-label > span"],
             :return_row_item_text => true, 
             :return_text_if_nil_result => false,
             :row_item_text_to_split_by_regex => {
               /(Безлимитные звонки)\s*(.*)/i => [1..2, 1..1], 
               /(Безлимитный интернет)\s*(.*)/i => [1..2, 1..1], 
               /(\d+)\s*(мин\S*)\s*(.*)/i => [2..3, 1..2], 
               /(\d+)\s*([МГ]б)\s*(.*)/i => [2..3, 1..2], 
               /(\d+)\s*((?:sms|смс))\s*(.*)/i => [2..3, 1..2], 
               /((?:.*тариф действует|.*действует на территории))\s*(.*)/i => [1..2, 1..1], 
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