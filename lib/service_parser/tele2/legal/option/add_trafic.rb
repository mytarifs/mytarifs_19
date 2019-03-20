module ServiceParser
  class Tele2
    class Legal::Option::AddTrafic < ServiceParser::Tele2
      def service_parsing_tags
        {
         :base_service_scope => ["div.page_primary"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.tbl-wrap"],
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :process_sub_block => {
               :select_only_first_column_and_column_with_chosen_head => [tarif_class.name.match(/^добавить трафик (.*)/i)[1]]},
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > table > tbody > tr"],
             :return_row_item_text => false,
             :param_name_tag => [" > td:nth-child(1)"],
             :param_value_tag => [" > td:nth-child(2)"],
           },
           {
             :block_tag => [" > div.notesApril"],
             :block_name_tag => ["h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["> div"],
             :process_sub_block => {},
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p"],
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