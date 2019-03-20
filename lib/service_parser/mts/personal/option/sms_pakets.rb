module ServiceParser
  class Mts
    class Personal::Option::SmsPakets < ServiceParser::Mts
      def service_parsing_tags
        periodic_sms_volume = (tarif_class.name.match(/^(.*?)sms.(\d+)\s?$/i) || [])[2]
        periodic_sms_volume = (tarif_class.name.match(/^(.*?)\s?(\d+)\s?sms$/i) || [])[2] if periodic_sms_volume.nil?
        onetime_sms_volume = (tarif_class.name.match(/^sms(.*?)\s?(\d+)?$/i) || [])[2]
        sms_volume = periodic_sms_volume || onetime_sms_volume || tarif_class.name
#        puts
#        puts tarif_class.name
#        puts [periodic_sms_volume, onetime_sms_volume, sms_volume].to_s
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > ul > li:contains('Разовые SMS-пакеты')"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Разовые SMS-пакеты"},
             
             :sub_block_tag => [" > table > tbody > tr:contains('#{tarif_class.name}')", " > table > tbody > tr:contains('#{sms_volume}')"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Стоимость подключения"},
             
             :row_tag => [],
             :return_row_item_text => false,
             :return_ony_own_param_name_text => false,
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
           {
             :block_tag => [" > table:nth-of-type(2)"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Разовые SMS-пакеты"},
             
             :sub_block_tag => [" > tbody > tr:contains('#{sms_volume}')"], 
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Стоимость подключения"},
             
             :row_tag => [],
             :return_row_item_text => false,
             :return_ony_own_param_name_text => false,
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
           {
             :block_tag => [" > ul > li:contains('Периодические SMS-пакеты')"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Периодические SMS-пакеты"},
             
             :sub_block_tag => [" > table > tbody > tr:contains('#{tarif_class.name}')", " > table > tbody > tr:contains('#{sms_volume}')"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Ежемесячная плата"},
             
             :row_tag => [],
             :return_row_item_text => false,
             :return_ony_own_param_name_text => false,
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
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