module ServiceParser
  class Mts
    class Legal::Option::BusinessPakets < ServiceParser::Mts
      def service_parsing_tags
        paket_volume, param_type = (tarif_class.name.match(/(\d+)\s*([[:word:]]*)/i) || [])[1..2]
#        puts
#        puts [tarif_class.name, paket_volume].to_s
#        puts
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.slider:contains('Сколько это стоит') > div > table", " > div.slider:contains('Сколько стоит') > div > table"],
             :outside_block_name_tag => ["h2", "h3", "p"],
             :block_name_tag => ["title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > tbody"], 
             :sub_block_name_substitutes => {"sub_block" => "Ежемесячная оплата"},
             
             :row_tag => [" > tr:contains('#{paket_volume}'):contains('#{param_type}')"],
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
           {
             :block_tag => [" > div.slider:contains('Сколько это стоит') > div > dl"],
             :block_name_tag => [" > dt > a"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > dd > table > tbody"], 
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Ежемесячная оплата"},
             
             :row_tag => [" > tr:contains('#{paket_volume}'):contains('#{param_type}')"],
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
         ]
        }
      end
    end
  end
end