module ServiceParser
  class Tele2
    class Personal::Option::DenVSeti < ServiceParser::Tele2
      def service_parsing_tags
        {
         :base_service_scope => ["div.page_primary"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.b-openable"],
             :block_name_tag => ["h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div > div.tbl-wrap"],
             :process_sub_block => {
#               :select_only_first_column_and_column_with_chosen_head => [tarif_class.name.match(/^добавить трафик (.*)/i)[1]]
             },
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > table > tbody > tr"],
             :return_row_item_text => false,
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
           {
             :block_tag => [" > div.tbl-wrap"],
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :process_sub_block => {
#               :select_only_first_column_and_column_with_chosen_head => [tarif_class.name.match(/^добавить трафик (.*)/i)[1]]
             },
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > table > tbody > tr"],
             :return_row_item_text => false,
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
           {
             :block_tag => [],
             :block_name_tag => [],
             :outside_block_name_tag => false,
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :process_sub_block => {},
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p", " > ul > li"],
             :return_row_item_text => true,
             :row_item_text_to_split_by_regex => {
               /^(При подключении услуги абоненту предоставляются)\s(\d*\s?[м|г]б)(.*)(\.{1,2})(.*)$/i => [3..3, 2..2], 
               /^(.*)[-|–|-](.*)$/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => [" > div.notesApril", " > div.b-openable"],
             :block_name_tag => ["h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["> div"],
             :process_sub_block => {},
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p", " > ul > li"],
             :return_row_item_text => true,
             :param_name_tag => [],
             :param_value_tag => [],
           },
         ]
        }
      end
    end
  end
end