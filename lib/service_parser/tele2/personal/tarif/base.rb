module ServiceParser
  class Tele2
    class Personal::Tarif::Base < ServiceParser::Tele2
      def service_parsing_tags
        {
         :base_service_scope => [],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.promo-slide"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "абонентская плата"},
             
             :sub_block_tag => [" > div.text-box"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > div.wrap"],
#             :return_row_item_text => true,
#             :return_text_if_nil_result => true,
             :param_name_tag => [],
             :param_value_tag => [" > div.price-wrap"],
           },
           {
             :block_tag => ["div.tariffs-box.tariffs-gray-left"],
             :block_name_tag => [" > div > h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["div.tariffs-box-holder"],
             :sub_block_name_tag => [" > h4"],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > ul > li"],
             :param_name_tag => ['span.title'],
             :param_value_tag => ["span.info"],
           },
           {
             :block_tag => ["div.tariffs-box > div.content-box div.print-element div.tariffs-box-holder"],
             :block_name_tag => [" > h4", " > div.tariff-info-title > h4"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div"],
             :sub_block_name_tag => [" > h5"],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["ul > li"],
             :param_name_tag => ['span.title'],
             :param_value_tag => ["span.info"],
           },
           {
             :block_tag => ["div.tariffs-box > div.content-box div.print-element > div > div:contains('В поездках по России')"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "условия в поездках по России"},
             
             :sub_block_tag => [" > p.additional-cond"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["span.additional-cond-fee-item"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /(.*?)(пакеты минут и sms)(.*)/i => [2..2, 0..0],
               /(.*?)(пакет минут)(.*)/i => [2..2, 0..0],
               /(.*?)(пакет sms)(.*)/i => [2..2, 0..0],
               /(.*?)(пакет интернета)(.*)/i => [2..2, 0..0],
               /(.*)/i => [2..2, 0..0],
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