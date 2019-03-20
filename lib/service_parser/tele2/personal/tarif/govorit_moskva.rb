module ServiceParser
  class Tele2
    class Personal::Tarif::GovoritMoskva < ServiceParser::Tele2
      def service_parsing_tags
        {
         :base_service_scope => ["div.page > div.service"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["> p + table"],
             :outside_block_name_tag => true,
             :block_name_tag => ["title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["tr"],
             :param_name_tag => ['td:nth-of-type(1)'],
             :param_value_tag => ['td:nth-of-type(n+2)'],
           },
           {
             :block_tag => ["> div > h3 + div"],
             :outside_block_name_tag => true,
             :block_name_tag => ["title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["tr"],
             :param_name_tag => ['td:nth-of-type(1)'],
             :param_value_tag => ['td:nth-of-type(n+2)'],
           },
         ]
        }
      end
    end
  end
end