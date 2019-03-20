module ServiceParser
  class Mts
    class Legal::Option::InternetPaketsForTravel < ServiceParser::Mts
      def service_parsing_tags
        destination, duration, volume = (tarif_class.name.match(/^.*?(Европе и странам МТС|странам мира)\s*(\d+).*?(\d+).*$/i) || [])[1..3]
        puts
        puts [tarif_class.name, destination, duration, volume].to_s
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.slider:contains('#{destination}') > div > table"],
             :block_name_tag => [" > h3"],
             :process_block => {:repaire_table => []},
             :block_name_substitutes => {"block" => "Стоимость подключения"},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "#{[destination, duration, volume].join(', ')}"},
             
             :row_tag => [" > tr:contains('#{duration} сут'):contains('#{volume} Мб')"],
             :param_name_tag => [" > td:nth-of-type(-n+3)"],
             :param_value_tag => [" > td:nth-of-type(4)"],
           },
         ]
        }
      end
    end
  end
end