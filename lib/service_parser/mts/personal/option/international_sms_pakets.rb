module ServiceParser
  class Mts
    class Personal::Option::InternationalSmsPakets < ServiceParser::Mts
      def service_parsing_tags
        sms_volume, sms_where = tarif_class.name.match(/^(\d*)\s?sms\s?(.*)$/i)[1..2]
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["> table.common"],
             :process_block => {
#               :add_header_to_column_in_table => [],
               :add_third_plus_columns_in_table_as_new_rows => [],
#               :select_only_first_column_and_column_with_chosen_head => [tarif_class.name.match(/^добавить трафик (.*)/i)[1]],
             },
             :block_name_tag => [],
             :block_name_substitutes => {"block" => "Стоимость подключения"},
             
             :sub_block_tag => [" > tbody > tr:contains('#{tarif_class.name}')"],
             :sub_block_name_tag => [" > td:nth-child(2)"],
             :sub_block_name_substitutes => {},
             
             :row_tag => [],
             :return_row_item_text => false,
             :return_ony_own_param_name_text => false,
             :param_name_tag => [" > td:nth-child(3)"],
             :param_value_tag => [" > td:nth-child(3)"],
           },
           {
             :block_tag => [" > div.slider"],
             :block_name_tag => ["h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div"],
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