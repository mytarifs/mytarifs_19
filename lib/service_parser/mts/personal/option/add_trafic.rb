module ServiceParser
  class Mts
    class Personal::Option::AddTrafic < ServiceParser::Mts
      def service_parsing_tags
        internet_volume, volume_units = tarif_class.name.match(/^Турбо-кнопка\s(\d*)\s?([м|г|m|g][б|b])/i)[1..2]
        {
         :base_service_scope => ["div.footer__to-bottom-content"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.turbo-tariff"],
             :outside_block_name_tag => false,
             :block_name_tag => ["div.turbo-tariff__size"],
             :block_name_substitutes_regex => {
               /^.*(#{internet_volume})\s?(#{volume_units})\s?(.*)$/i => [1, 2,], 
             },
             :block_names_to_exclude => ["wrong_name"],
             
             :sub_block_tag => [" > div.turbo-tariff__body"],
             :process_sub_block => {},
             :return_ony_own_sub_block_text => true,
             :sub_block_name_tag => [" > div > div.turbo-tariff__date", " > div > div.turbo-tariff__time"],
             :sub_block_name_substitutes => {"30суток" => "Абонентская плата в месяц", "24часа" => "Абонентская плата в сутки"},
             
             :row_tag => ["div.turbo-tariff__row"],
#             :return_row_item_text => false,
#             :return_ony_own_param_name_text => true,
             :param_name_tag => [],
             :return_ony_own_param_value_text => true,
             :param_value_tag => [" > div.turbo-tariff__price"],
           },
           {
             :block_tag => ["div.turbo-details__content-item:contains('#{internet_volume} #{volume_units}')"],
             :outside_block_name_tag => false,
             :block_name_tag => ["div.turbo-details__title"],
             :block_names_to_exclude => ["wrong_name"],
             
             :sub_block_tag => ["div.turbo-details__row"],
             :process_sub_block => {},
#             :return_ony_own_sub_block_text => true,
             :sub_block_name_tag => [" > div.turbo-details__label"],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > div.turbo-details__value"],
#             :return_row_item_text => false,
             :return_ony_own_param_name_text => true,
             :param_name_tag => [],
             :return_ony_own_param_value_text => true,
             :param_value_tag => [" > p"],
           },
         ]
        }
      end
    end
  end
end