module ServiceParser
  class Mts
    class Legal::Option::SmsPakets < ServiceParser::Mts
      def service_parsing_tags
        sms_volume = (tarif_class.name.match(/^(.*?)sms.(\d+)\s?$/i) || [])[2]
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > table:nth-of-type(1)"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Периодические SMS-пакеты"},
             
             :sub_block_tag => [" > tbody > tr:contains('#{sms_volume}')"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Ежемесячная плата"},
             
             :row_tag => [],
             :return_row_item_text => false,
             :return_ony_own_param_name_text => false,
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
         ]
        }
      end
    end
  end
end