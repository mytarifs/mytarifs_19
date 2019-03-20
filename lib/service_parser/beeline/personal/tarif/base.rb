module ServiceParser
  class Beeline
    class Personal::Tarif::Base < ServiceParser::Beeline
      def page_special_action_steps
        keys_selector = [
          "div[class*='ProductCard_descriptions'] div[class*='Descriptions_navbar'] div[class*='Descriptions_navbarItem'] > span",
          "div[class*='_2KaepnnPeS'] div[class*='_1uZ4f0JlrD'] div[class*='_3yIoJzmAVJ'] > span",
        ]
        nodes_with_keys = check_and_return_all_nodes_with_scope(doc, keys_selector) || []
        keys = nodes_with_keys.map{|nodes_with_key| nodes_with_key.try(:text)}
        [
          {
            :keys => keys,
            :select => 
              {
                :scope => ["div[class*='Descriptions_navbar_']", "div[class*='_1uZ4f0JlrD']"],
                :element_tags => [
                  {:css => "div[class*='Descriptions_navbarItem_'] > span", :visible => true, :type => :find},
                  {:css => "div[class*='_3yIoJzmAVJ'] > span", :visible => true, :type => :find},
                ],
                :use_key => true,
              },
            :scope_to_save_tags => ["div[class*='Descriptions_content_']", "div[class*='_1btVhtQJjH']"],
          }
        ]
      end 

      def service_parsing_tags
        {
         :base_service_scope => [],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["page_place_for_special_action_result > div[class*='Descriptions_content']", "page_place_for_special_action_result > div[class*='_1btVhtQJjH']"],
             :block_name_tag => ["div[class*='Descriptions_heading']", "div[class*='_3rN4Zi073c']"],
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
             :block_tag => ["page_place_for_special_action_result > div[class*='_1btVhtQJjH']"],
             :block_name_tag => ["div[class*='_3rN4Zi073c']"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [' > td:nth-of-type(1)', ' > td:nth-of-type(1) > span',],
             :param_value_tag => [' > td:nth-of-type(2) > span', ' > td:nth-of-type(2) > span > span',],
           },
           {
             :block_tag => ["div.tariff-description > h3 + div.table-dropdown-list-cnt"],
             :outside_block_name_tag => true,
             :block_name_tag => ["title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["> div > table > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [' > td:nth-of-type(1)',],
             :param_value_tag => [' > td:nth-of-type(n+2)',],
           },
           {
             :block_tag => ["div.tariff-description > div > h4 + div",],
             :outside_block_name_tag => true,
             :block_name_tag => ["title"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["table > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [' > td:nth-of-type(1)',],
             :param_value_tag => [' > td:nth-of-type(n+2)',],
           },
           {
             :block_tag => ["div.tariff-description > div > h4 + div",],
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
         ]
        }
      end
    end
  end
end