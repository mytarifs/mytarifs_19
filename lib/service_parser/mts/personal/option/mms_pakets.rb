module ServiceParser
  class Mts
    class Personal::Option::MmsPakets < ServiceParser::Mts
      def service_parsing_tags
        periodic_mms_volume = (tarif_class.name.match(/^(.*?)mms.(\d+)\s?$/i) || [])[2]
#        puts
#        puts tarif_class.name
#        puts [periodic_sms_volume, onetime_sms_volume, sms_volume].to_s
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [],
             :block_name_tag => [" > h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > table > tbody > tr:contains('#{tarif_class.name}')"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Стоимость подключения"},
             
             :row_tag => [],
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
           {
             :block_tag => [" > div.slider"],
             :block_name_tag => ["h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p", " > ul > li"],
             :return_row_item_text => true,
             :param_name_tag => [],
             :param_value_tag => [],
           },
         ]
        }
      end
    end
  end
end