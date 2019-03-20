module ServiceParser
  class Mts
    class Personal::Option::InternetWithSpeed < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["div.footer__to-bottom-content", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.product-params"],
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["div.product-params__row"],
             :sub_block_name_tag => ["div.product-params__opener div.product-params__title span"],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.product-params__info"],
#             :return_ony_own_param_name_text => true, 
             :param_name_tag => ["div.product-params__info-label"],
#             :return_ony_own_param_value_text => true, 
             :param_value_tag => ["div.product-params__info-value span"],
           },

         ]
        }
      end 

    end
  end
end