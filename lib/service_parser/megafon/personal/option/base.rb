module ServiceParser
  class Megafon
    class Personal::Option::Base < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.b-layout-left__wrapper", "div.p-roaming-solution", "div.d-service i-bem"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["> div.b-tariff-description"],
             :block_name_tag => ["h1"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [],
             :param_name_tag => [],
             :param_value_tag => ['h3',],
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
           {
             :block_tag => ["> div.b-text"],
             :block_name_tag => [],
             :block_name_substitutes => {"block" => " Сноска к таблице"},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [' > div.b-text__content > p'],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /(.*?)утра(.*?)до(.*?)ночи(.*?)(\d+ ГБ)(.*)/i => [6..6, 5..5],
             }, 
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => ["> div.b-accordion_view_tariff"],
             :block_name_tag => ['dt.b-accordion__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => ['dd.b-accordion__content div' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.b-tariff-table__row"],
             :param_name_tag => ['div.b-tariff-table__data-title'],
             :param_value_tag => ['div.b-tariff-table__data-content'],
           },
           {
             :block_tag => ["> div.b-accordion_view_tariff-features"],
             :block_name_tag => ['dt.b-accordion__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => ['dd.b-accordion__content div' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.b-tariff-features__content"],
             :param_name_tag => ['p:nth-of-type(1)'],
             :param_value_tag => ['p:nth-of-type(n+2)'],
           },
           {
             :block_tag => ["> div.b-accordion_view_tariff-features"],
             :block_name_tag => ['dt.b-accordion__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => ['dd.b-accordion__content div' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.b-text__content"],
             :param_name_tag => [],
             :param_value_tag => ['p'],
           },
# for use with div.p-roaming-solution
           {
             :block_tag => ["div.b-roaming-prices"],
             :block_name_tag => ['h2'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > table > tbody' ],
             :sub_block_name_tag => [" > tr:first-of-type"],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr:nth-of-type(n+2)"],
             :param_name_tag => ['> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > td:nth-of-type(n+2)'],
           },
           {
             :block_tag => ["dl.b-spoiler"],
             :block_name_tag => [' > dt.b-spoiler__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > dd.b-spoiler__content' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
           },
# for use with div.p-roaming-solution
           {
             :block_tag => ["div.d-service__tabsblock > div > table"],
#             :process_block => {:repaire_table => []},
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > tbody' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {"sub_block" => "Стоимость"},
             
             :row_tag => [" > tr"],
             :param_name_tag => ['> td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > td:nth-of-type(n+2)'],
           },


# general
           {
             :block_tag => ["dl.b-spoiler"],
             :block_name_tag => [' > dt.b-spoiler__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > dd.b-spoiler__content' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > ul > li"],
             :return_row_item_text => true, 
             :return_row_item_text_with_children_text => true, 
           },
#####           
         ]
        }
      end 
    end
  end
end