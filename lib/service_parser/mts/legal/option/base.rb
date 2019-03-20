module ServiceParser
  class Mts
    class Legal::Option::Base < ServiceParser::Mts
      def service_parsing_tags
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
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
           {
             :block_tag => [],
             :block_name_tag => ["h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p"],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true,
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /.*(Ежедневная плата за Услугу.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(Ежемесячная плата за Услугу.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(Ежемесячная плата за опцию.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(Стоимость подключения Услуги.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(ежесуточная плата за использование опции.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(ВСЕ входящие звонки.*?)\s*(.*).*/i => [1..1, 2..2], 
               /.*(исходящие звонки на любые телефоны домашнего региона.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(исходящие междугородные звонки на любые телефоны всех остальных регионов России.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /^(подключение.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /^(\* В рамках опции предоставляется.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
#               /^(Ежемесячная плата.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /^(.*звоните всего за.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*,(Плата за использование опции.*и составляет.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },     
           {
             :block_tag => [],
#             :outside_block_name_tag => true,
#             :block_name_attributes_to_text => ['title'],
#             :block_name_tag => ["title"],
             :block_name_tag => ["h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > ul > li"],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true,
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /.*(Ежедневная плата за Услугу.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(Ежемесячная плата за Услугу.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(Ежемесячная плата за опцию.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(Стоимость подключения Услуги.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(ежесуточная плата за использование опции.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(ВСЕ входящие звонки.*?)\s*(.*).*/i => [1..1, 2..2], 
               /.*(исходящие звонки на любые телефоны домашнего региона.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(исходящие междугородные звонки на любые телефоны всех остальных регионов России.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /^(подключение.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /^(исходящие SMS.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },           {
             :block_tag => [" > dl.dlist:contains('Стоимость')", " > div.slider:contains('Сколько стоит')"],
             :block_name_tag => ["h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > dd > ul > li", " > div > ul > li"],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true,
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /^(Стоимость подключения.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /^(Ежесуточная плата.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /^(Ежемесячная плата.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /(Ежедневная плата.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /^(подключение.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /^(подключение.*?).*?(Ежемесячная плата.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [2..2, 3..3], 
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