module ServiceParser
  class Mts
    class Personal::Option::MiniBit < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > table.list"],
             :process_block => {:repaire_table => []},
             :block_name_tag => [],
             :block_name_substitutes => {'block' => 'интернет'},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {'sub_block' => 'первые МБ'},
             
             :row_tag => [" > tr"],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true,
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /(?=(.*?первые.*последующие.*\s?\d+\s?мб))\1.*?(\s?\d+\s?руб\.\s?).*?(\s?\d+\s?руб\.\s?).*/i => [1..1, 2..2], 
               /(?=^((?!последующие).)*$)(.*первые\s?\d+\s?мб.*?)(\s?\d+\s?руб\.\s?).*?(\s?\d+\s?руб\.\s?)?.*$/i => [2..2, 3..3], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => [" > table.list"],
             :process_block => {:repaire_table => []},
             :block_name_tag => [],
             :block_name_substitutes => {'block' => 'интернет'},
             
             :sub_block_tag => [" > tbody"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {'sub_block' => 'последующие МБ'},
             
             :row_tag => [" > tr"],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true,
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex =>  {
               /(?=(.*?первые.*последующие.*\s?\d+\s?мб))\1.*?(\s?\d+\s?руб\.\s?).*?(\s?\d+\s?руб\.\s?).*/i => [1..1, 3..3], 
               /(?=^((?!первые).)*$)(.*последующие\s?\d+\s?мб.*?)(\s?\d+\s?руб\.\s?).*?(\s?\d+\s?руб\.\s?)?.*$/i => [2..2, 3..3], 
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