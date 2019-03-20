module ServiceParser
  class Megafon
    class Personal::Option::SmsOptions < ServiceParser::Megafon
      def service_parsing_tags
        short_sms_name = tarif_class.name.match(/^Опция для\s(.*)/i)[1] #SMS L SMS L
        {
         :base_service_scope => ["div.d-service", "div.b-layout-left__wrapper"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.b-page__content > div.d-service__tabsblock table"],
             :process_block => {
               :transponse_table => [],
               :select_only_first_column_and_column_with_chosen_head => ["#{short_sms_name}"],
             },
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > tbody' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => ['> th:nth-of-type(1)', '> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > td:nth-of-type(n+1)'],
           },

           {
             :block_tag => ["> div.b-tariff-table"],
             :block_name_tag => ['div.b-text__content.b-tariff-features'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.b-tariff-table__row"],
             :param_name_tag => ['div.b-tariff-table__data-title',],
             :param_value_tag => ['div.b-tariff-table__data-content',],
           },
         ]
        }
      end 
    end
  end
end