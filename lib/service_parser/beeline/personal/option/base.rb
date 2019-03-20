module ServiceParser
  class Beeline
    class Personal::Option::Base < ServiceParser::Beeline
      def page_special_action_steps
        keys_selector = [
          "div[class*='ProductCard_descriptions'] div[class*='Descriptions_navbar'] div[class*='Descriptions_navbarItem'] > span",
          "div[class*='_2KaepnnPeS'] div[class*='_1uZ4f0JlrD'] div[class*='_3yIoJzmAVJ'] > span",
          "ul.promo-convergence_additional_tabs-nav > li > h4 > span",
        ]
        nodes_with_keys = check_and_return_all_nodes_with_scope(doc, keys_selector) || []
        keys = nodes_with_keys.map{|nodes_with_key| nodes_with_key.try(:text)}
        [
          {
            :keys => keys,
            :select => 
              {
                :scope => ["div[class*='Descriptions_navbar_']", "div[class*='_1uZ4f0JlrD']", "#lteparameters"],
                :element_tags => [
                  {:css => "div[class*='Descriptions_navbarItem_'] > span", :visible => true, :type => :find},
                  {:css => "div[class*='_3yIoJzmAVJ'] > span", :visible => true, :type => :find},
                  {:css => "ul.promo-convergence_additional_tabs-nav > li > h4 > span", :visible => true, :type => :find},
                ],
                :use_key => true,
              },
            :scope_to_save_tags => ["div[class*='Descriptions_content_']", "div[class*='_1btVhtQJjH']", "div.promo-convergence_additional_tabs-cnt"],
          }
        ]
      end 

      def service_parsing_tags
        {
         :base_service_scope => [],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["page_place_for_special_action_result > div[class*='Descriptions_content']"],
             :block_name_tag => ["div[class*='Descriptions_heading']"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [' > td:nth-of-type(1)', ' > td:nth-of-type(1) > span',],
             :param_value_tag => [' > td:nth-of-type(2) > span', ' > td:nth-of-type(2) > span > span',],
           },
           {
             :block_tag => ["page_place_for_special_action_result > div[class*='Descriptions_content']"],
             :block_name_tag => ["div[class*='Descriptions_heading']"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Пакет услуг"},
             
             :row_tag => [" > tr"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
             :row_item_text_to_split_by_regex => {
               /(Безлимитные звонки)\s*(.*)/i => [1..2, 1..1], 
               /(Безлимитный интернет)\s*(.*)/i => [1..2, 1..1], 
               /(\d+\s*рублей)?\s*(за входящие звонки в (?:поездках по миру|международном роуминге))\s*(.*)/i => [1..2, 3..3], 
               /(\d+)\s*(мин\S*)\s*(.*)/i => [2..3, 1..2], 
               /(\d+)\s*([МГ]б)\s*(.*)/i => [2..3, 1..2], 
               /(\d+)\s*((?:sms|смс))\s*(.*)/i => [2..3, 1..2], 
               /((?:.*тариф действует|.*действует на территории))\s*(.*)/i => [1..2, 1..1], 
               /(при подключении новых номеров)\s*(.*)/i => [1..1, 2..2], 
             },
           },

           {
             :block_tag => ["div.service-description #paramGroups > h4 + div"],
             :outside_block_name_tag => true,
             :block_name_tag => ["title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["tr"],
             :param_name_tag => ['td:nth-of-type(1)',],
             :param_value_tag => ['td:nth-of-type(n+2)',],
           },
           {
             :block_tag => ["div.service-description #paramGroups > h4 + div"],
             :outside_block_name_tag => true,
             :block_name_tag => ["title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Пакет услуг"},
             
             :row_tag => [" > tr"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
             :row_item_text_to_split_by_regex => {
               /(Безлимитные звонки)\s*(.*)/i => [1..2, 1..1], 
               /(Безлимитный интернет)\s*(.*)/i => [1..2, 1..1], 
               /(\d+\s*рублей)?\s*(за входящие звонки в (?:поездках по миру|международном роуминге))\s*(.*)/i => [1..2, 3..3], 
               /(\d+)\s*(мин\S*)\s*(.*)/i => [2..3, 1..2], 
               /(\d+)\s*([МГ]б)\s*(.*)/i => [2..3, 1..2], 
               /(\d+)\s*((?:sms|смс|SMS))\s*(.*)/i => [2..3, 1..2], 
               /((?:.*тариф действует|.*действует на территории))\s*(.*)/i => [1..2, 1..1], 
               /(при подключении новых номеров)\s*(.*)/i => [1..1, 2..2], 
             },
           },
           {
             :block_tag => ["page_place_for_special_action_result > div.promo-convergence_additional_tabs-cnt > div.promo-convergence_additional_tab"],
             :block_name_tag => [" > h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div.promo-convergence_parameters_line-content"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > div"],
             :param_name_tag => [' > div > h3',],
             :param_value_tag => [' > div > span',],
           },
           {
             :block_tag => ["page_place_for_special_action_result > div.promo-convergence_additional_tabs-cnt > div.promo-convergence_additional_tab"],
             :block_name_tag => [" > h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div.promo-convergence_parameters_line-content"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Пакет услуг"},
             
             :row_tag => [" > div"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
             :row_item_text_to_split_by_regex => {
               /(Безлимитные звонки)\s*(.*)/i => [1..2, 1..1], 
               /(Безлимитный интернет)\s*(.*)/i => [1..2, 1..1], 
               /(\d+\s*рублей)?\s*(за входящие звонки в (?:поездках по миру|международном роуминге))\s*(.*)/i => [1..2, 3..3], 
               /(\d+)\s*(мин\S*)\s*(.*)/i => [2..3, 1..2], 
               /(\d+)\s*([МГ]б)\s*(.*)/i => [2..3, 1..2], 
               /(\d+)\s*((?:sms|смс))\s*(.*)/i => [2..3, 1..2], 
               /((?:.*тариф действует|.*действует на территории))\s*(.*)/i => [1..2, 1..1], 
               /(при подключении новых номеров)\s*(.*)/i => [1..1, 2..2], 
             },
           },         ]
        }
      end
    end
  end
end