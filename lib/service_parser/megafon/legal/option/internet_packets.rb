module ServiceParser
  class Megafon
    class Legal::Option::InternetPackets < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.d-tariff-remote-option"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.b-b2b-text"],
             :block_name_tag => [" > h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > table.tariff_remote_params > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > td:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(2)"],
           },
           {
             :block_tag => ["div.b-b2b-text > div.acc-section"],
             :block_name_tag => [" > div.acc-header > h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div > table.tariff_remote_option_params > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > td:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(2)"],
           },
           {
             :block_tag => ["div.b-b2b-text"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Объем интернета"},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [' > p'],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /(.*?)утра(.*?)до(.*?)ночи(.*?)(\d+ ГБ)(.*)/i => [1..5, 5..5],
               /(.*?)Объем трафика(.*?)(\d+ ГБ)(.*?)7:00(.*?)/i => [0..0, 3..3],
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