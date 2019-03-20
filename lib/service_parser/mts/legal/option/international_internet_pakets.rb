module ServiceParser
  class Mts
    class Legal::Option::InternationalInternetPakets < ServiceParser::Mts
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
             :block_tag => ["div.slider:contains('Сколько стоит')"],
             :block_name_tag => [" > h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table > tbody"],
             :process_sub_block => {:add_header_to_column_in_table => []},
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => 'Квота трафика'},
             
             :row_tag => [" > tr:contains('Квота трафика')"],
             :param_name_tag => [" > td:nth-of-type(2)"],
             :param_value_tag => [" > td:nth-of-type(3)"],
           },
           {
             :block_tag => ["div.slider:contains('Сколько стоит')"],
             :block_name_tag => [" > h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table > tbody"],
#             :process_sub_block => {:add_header_to_column_in_table => []},
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => 'Плата в сутки'},
             
             :row_tag => [" > tr:contains('Плата в сутки')"],
             :param_name_tag => [" > td:nth-of-type(2)"],
             :param_value_tag => [" > td:nth-of-type(4)"],
           },

         ]
        }
      end
    end
  end
end