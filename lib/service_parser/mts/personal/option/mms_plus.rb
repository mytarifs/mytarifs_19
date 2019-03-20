module ServiceParser
  class Mts
    class Personal::Option::MmsPlus < ServiceParser::Mts::Personal::Option::Base
      def page_special_action_steps
        [
          {
            :keys => [nil],
            :start_select=> 
              {
                :scope => ["div.region-list-control"],
                :element_tags => [{:css => 'a', :visible => true}],
              },
            :select => 
              {
                :scope => ["#tabletitleHiddenField"],
                :element_tags => [{:css => 'a', :text => 'RED Energy', :visible => true}, {:css => 'a', :text => 'Супер МТС', :visible => true}],
                :use_key => false,
              },
            :fail_select => 
              {
                :scope => ["#tabletitleHiddenField"],
                :element_tags => [{:css => 'a.closer', :visible => true}],
              },
            :scope_to_save_tags => ["#paramlistdiv"],
          }
        ]
      end 

      def service_parsing_tags
        {
         :base_service_scope => ["#mainForm", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.slider"],
#             :outside_block_name_tag => true,
#             :block_name_attributes_to_text => ['title'],
#             :block_name_tag => ["title"],
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
             :block_tag => ["#paramlistdiv"],
             :block_name_tag => [],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :return_ony_own_sub_block_text => true,
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p"],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true,
             :row_item_text_to_split_by_regex => {
               /(?=.*(^Подключение.*?))(?=.*\s+(#{broad_float_number_regex_string}))\1.*\s+\2.*/i => [1..1, 2..2], 
               /(?=.*(#{day_regex_string}|#{month_regex_string}))(?=.*(Плата за пользование услугой.*?))(?=.*\s+(#{broad_float_number_regex_string})).*\2.*\3.*\1.*/i => [1..2, 3..3], 
               /(.*):(.*)/i => [1..1, 2..2], 
             },
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
             
             :row_tag => [" > p", " > ul > li"],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true,
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /.*(Ежедневная плата за Услугу.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(Ежемесячная плата за Услугу.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(Стоимость подключения Услуги.*?)\s*(#{broad_float_number_regex_string}\s?[[:word:]]*).*/i => [1..1, 2..2], 
               /.*(Для остальных тарифных планов.*?)(Стоимость.*?c подключен[н]?ой услугой.*?)\s*(\d+,?\d*\s?[[:word:]]*).*/i => [1..2, 3..3], 
               /.*(Для тарифных планов.*?)(Стоимость.*?c подключен[н]?ой услугой.*?)\s*(\d+,?\d*\s?[[:word:]]*).*/i => [1..2, 3..3], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => [" > div.popup_mts-services"],
#             :outside_block_name_tag => true,
#             :block_name_attributes_to_text => ['title'],
#             :block_name_tag => ["title"],
             :block_name_tag => [" > div.request__section > h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div.request-popup_payment"],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.connection-payment"],
             :return_row_item_text => true,
             :return_row_item_text_with_children_text => true,
             :return_multi_results_row_item_text_to_split_by_regex => true,
             :row_item_text_to_split_by_regex => {
               /(?=.*(Подключение.*?))(?=.*\s+(#{broad_float_number_regex_string})).*\1.*\s+\2.*/i => [1..1, 2..2], 
               /(?=.*(#{day_regex_string}|#{month_regex_string}))(?=.*(Абонентская плата.*?))(?=.*\s+(#{broad_float_number_regex_string})).*\2.*\3.*\1.*/i => [1..2, 3..3], 
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