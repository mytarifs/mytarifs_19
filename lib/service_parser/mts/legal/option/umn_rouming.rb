module ServiceParser
  class Mts
    class Legal::Option::UmnRouming < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > table:contains('Страна пребывания')"],
             :outside_block_name_tag => ["h3"],
             :block_name_tag => ["title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [" > tr:nth-of-type(2) > td:nth-of-type(2)"],
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > td:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(2)"],
           },
           {
             :block_tag => [" > table:contains('Страна пребывания')"],
             :outside_block_name_tag => ["h3"],
             :block_name_tag => ["title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [" > tr:nth-of-type(2) > td:nth-of-type(3)"],
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > td:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(3)"],
           },
           {
             :block_tag => [" > table:contains('Подключение')"],
             :outside_block_name_tag => ["h3"],
             :block_name_tag => ["title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             
             :row_tag => [" > tr"],
             :param_name_tag => [" > td:nth-of-type(1)"],
             :param_value_tag => [" > td:nth-of-type(2)"],
           },
         ]
        }
      end 

    end
  end
end