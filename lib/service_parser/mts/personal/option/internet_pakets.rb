module ServiceParser
  class Mts
    class Personal::Option::InternetPakets < ServiceParser::Mts
      def service_parsing_tags
#        periodic_sms_volume = (tarif_class.name.match(/^(.*?)sms.(\d+)\s?$/i) || [])[2]
#        puts
#        puts tarif_class.name
#        puts [periodic_sms_volume, onetime_sms_volume, sms_volume].to_s
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.tarif_item:contains('#{tarif_class.name}')"],
             :block_name_tag => [" > div.tarif_title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div.tarif_block.first"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "интернет, Объем пакета"},
             
             :row_tag => [],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true, 
             :row_item_text_to_split_by_regex => {
               /(?=.*(#{day_regex_string}|#{month_regex_string}))(?=.*?(#{broad_float_number_regex_string}\s?#{internet_volume_unit_regex_string})).*\2.*\1.*/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => ["div.tarif_item:contains('#{tarif_class.name}')"],
             :block_name_tag => [" > div.tarif_title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div.tarif_block.second > div.tarif_price"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "интернет, Стоимость пакета"},
             
             :row_tag => [],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true, 
             :row_item_text_to_split_by_regex => {
               /(?=.*(#{day_regex_string}|#{month_regex_string}))(?=.*?(#{broad_float_number_regex_string})).*\2.*\1.*/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => ["div.tarif_item:contains('#{tarif_class.name}')"],
             :block_name_tag => [" > div.tarif_title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div.tarif_block.bottom_horizontal"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "интернет, действует на территории"},
             
             :row_tag => [],
             :param_name_tag => [" > h3"],
             :param_value_tag => [],
           },
         ]
        }
      end
    end
  end
end