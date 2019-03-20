module ServiceParser
  class Mts
    class Legal::Option::InternetPakets < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           ({
             :block_tag => [" > div > div > table.internet_table"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Бит"},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > th"],
             :param_value_tag => ["> td:nth-of-type(1)"],
           } if tarif_class.name == 'БИТ'),
           ({
             :block_tag => [" > div > div > table.internet_table"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Бит"},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Квота трафика"},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > th"],
             :return_ony_own_param_value_text => true,
             :param_value_tag => ["> td:nth-of-type(1) > div"],
           } if tarif_class.name == 'БИТ'),
           ({
             :block_tag => [" > div > div > table.internet_table"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Бит"},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Стоимость опции"},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > th"],
             :return_ony_own_param_value_text => true,
             :param_value_tag => ["> td:nth-of-type(1) > div > b", "> td:nth-of-type(1) > div > nobr > b"],
           } if tarif_class.name == 'БИТ'),
           ({
             :block_tag => [" > div > div > table.internet_table"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "СуперБит"},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > th"],
             :param_value_tag => ["> td:nth-of-type(2)"],
           } if tarif_class.name == 'СуперБИТ'),
           ({
             :block_tag => [" > div > div > table.internet_table"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "СуперБит"},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Квота трафика"},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > th"],
             :return_ony_own_param_value_text => true,
             :param_value_tag => ["> td:nth-of-type(2) > div"],
           } if tarif_class.name == 'СуперБИТ'),
           ({
             :block_tag => [" > table.list"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "МТС Планшет"},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Квота трафика"},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > th:nth-of-type(4)"],
             :return_ony_own_param_value_text => true,
             :param_value_tag => ["> td:nth-of-type(4)"],
           } if tarif_class.name == 'МТС Планшет'),
           ({
             :block_tag => [" > table.list"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "МТС Планшет"},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Стоимость опции"},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > th:nth-of-type(5)"],
             :return_ony_own_param_value_text => true,
             :param_value_tag => ["> td:nth-of-type(5) > nobr"],
           } if tarif_class.name == 'МТС Планшет'),
           ({
             :block_tag => ["div.internet-table-container > table.internet_table"],
             :process_block => {:repaire_table => [], :transponse_table => []},
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Интернет пакет#{tarif_class.name}"},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Ежемесячная плата"},
             
             :row_tag => [" > tr:contains('#{tarif_class.name}')"],
             :param_name_tag => [" > th:nth-of-type(2)"],
             :param_value_tag => ["> td:nth-of-type(1)"],
           } if tarif_class.name =~ /Интернет-(Mini|Maxi|VIP|TOP|Premium)/i),
           ({
             :block_tag => ["div.internet-table-container > table.internet_table"],
             :process_block => {:repaire_table => [], :transponse_table => []},
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Интернет пакет #{tarif_class.name}"},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Квота трафика в месяц"},
             
             :row_tag => [" > tr:contains('#{tarif_class.name}')"],
             :param_name_tag => [" > th:nth-of-type(3)"],
             :param_value_tag => [" > td:nth-of-type(2)"],
           } if tarif_class.name =~ /Интернет-(Mini|Maxi|VIP|TOP|Premium)/i),
         ].compact
        }
      end
    end
  end
end