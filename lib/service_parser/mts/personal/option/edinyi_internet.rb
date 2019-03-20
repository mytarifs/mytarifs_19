module ServiceParser
  class Mts
    class Personal::Option::EdinyiInternet < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["div.footer__to-bottom-content", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.bigbanner__text-valign"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => 'Ежемесячная плата'},
             
             :sub_block_tag => [],
             :return_ony_own_sub_block_text => true,
             :sub_block_name_tag => [" > div.bigbanner__price-title"],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.bigbanner__price"],
             :return_row_item_text => true,
             :sub_block_text_to_split_by_regex => {
               /(?=.*(\d+))(?=(.*)).*\1.*\2/i => [2..2, 1..1],                
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