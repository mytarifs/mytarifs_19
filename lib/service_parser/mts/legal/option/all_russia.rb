module ServiceParser
  class Mts
    class Legal::Option::AllRussia < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["#mainForm"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > ul"],
             :outside_block_name_tag => true,
             :block_name_tag => ["title"],
             :block_name_substitutes => {"сколькостоит" => "Абонентская плата"},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > li"],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true,
             :row_item_text_to_split_by_regex => {
               /(.*)[:|–|-]\s(.*)/i => [1..1, 2..2],
               /(.*)/i => [0..0, 1..1],
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