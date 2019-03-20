module ServiceParser
  class Mts
    class Personal::Tarif::Base < ServiceParser::Mts
      def service_parsing_tags
        row_item_text_to_split_by_regex_for_bp_div = {
           /(Безлимитные звонки)\s*(.*)/i => [1..2, 1..1], 
           /(?=.*(интернета .?днем.*?))(?=.*\s+(\d+))(?=.*\s+(#{internet_volume_unit_regex_string})).*\2.*\3.*\1.*/i => [1..1, 2..3], 
           /(Безлимитный интернет)\s*(.*)/i => [1..2, 1..1], 
           /(\d+\s*рублей)?\s*(за входящие звонки в (?:поездках по миру|международном роуминге))\s*(.*)/i => [1..2, 3..3], 
           /(\d+)\s*(мин\S*)\s*(.*)/i => [2..3, 1..2], 
           /(\d+)\s*([МГ]б)\s*(.*)/i => [2..3, 1..2], 
           /(\d+)\s*((?:sms|смс))\s*(.*)/i => [2..3, 1..2], 
           /((?:.*тариф действует|.*действует на территории))\s*(.*)/i => [1..2, 1..1], 
           /(при подключении новых номеров)\s*(.*)/i => [1..1, 2..2], 
        }

        {
         :base_service_scope => ["#tariffData div.h-nt-lego-inner", ],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.bp-holder:nth-of-type(1)"],
#             :outside_block_name_tag => true,
#             :block_name_attributes_to_text => ['title'],
#             :block_name_tag => ["title"],
             :block_name_tag => ["h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => ["> div.FederalHolderMarker:nth-of-type(-n+2)"],
             :sub_block_name_tag => [" > table > tbody > tr > td > div"],
             :return_ony_own_sub_block_text => true,
             :sub_block_text_to_split_by_regex => {
               /(?=.*(плат))(?=.*(#{day_regex_string}|#{month_regex_string})).*\2.*\1.*/i => [1..2, 1..1],                
             },
             :sub_block_name_substitutes => {'sub_block' => "ежемесячный платеж"},
             
             :row_tag => [" > table.base-params > tbody > tr"],
             :param_name_tag => [],
             :param_value_tag => ['> td > span.price',],
           },
           {
             :block_tag => ["div.bp-holder > div.FederalHolderMarker:nth-of-type(1)"],
#             :outside_block_name_tag => true,
#             :block_name_attributes_to_text => ['title'],
#             :block_name_tag => ["title"],
             :block_name_tag => ["h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > table.base-params > tbody > tr > td"],
             :return_ony_own_sub_block_text => true,
             :sub_block_name_tag => ["div.bp-div"],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.bp-div > ul > li"],
             :return_row_item_text => true, 
             :row_item_text_to_split_by_regex => row_item_text_to_split_by_regex_for_bp_div,
             :return_ony_own_param_name_text => false,
             :param_name_tag => [],
             :return_ony_own_param_value_text => true,
             :param_value_tag => [],
           },
           {
             :block_tag => ["div.bp-holder:contains('В плату по тарифу включено')"],
#             :outside_block_name_tag => true,
#             :block_name_attributes_to_text => ['title'],
#             :block_name_tag => ["title"],
             :block_name_tag => ["h3.FederalHolderMarker"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [" > div.FederalHolderMarker > table.base-params > tbody > tr > td", ],
             :return_ony_own_sub_block_text => true,
             :sub_block_name_tag => ["div.bp-div"],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["div.bp-div"],
             :return_row_item_text => true, 
             :row_item_text_to_split_by_regex => row_item_text_to_split_by_regex_for_bp_div,
             :return_ony_own_param_name_text => false,
             :param_name_tag => [],
             :return_ony_own_param_value_text => true,
             :param_value_tag => [],
           },           
           {
             :block_tag => [" > div.bp-holder:nth-of-type(n+2)"],
#             :outside_block_name_tag => true,
#             :block_name_attributes_to_text => ['title'],
#             :block_name_tag => ["title"],
             :block_name_tag => ["h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {'no_sub_block' => 'лимит бесплатных минут'},
             
             :row_tag => [" > div.FederalHolderMarker > table.base-params > tbody > tr div.bp-div"],
             :return_row_item_text => true, 
             :return_text_if_nil_result => false,
             :row_item_text_to_split_by_regex => {
               /(?=(.*))(?=.*\s(с[о]?\s*?\d+.*?минут[ы]? в сутки)).*\2.*/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
           },
           {
             :block_tag => [" > div.bp-holder:nth-of-type(n+2)"],
#             :outside_block_name_tag => true,
#             :block_name_attributes_to_text => ['title'],
#             :block_name_tag => ["title"],
             :block_name_tag => ["h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => ["> div.FederalHolderMarker > table.base-params > tbody > tr"],
             :param_name_tag => ["> td:nth-of-type(2)"],
             :param_value_tag => ['> td:nth-of-type(1)',],
           },
         ]
        }
      end 
    end
  end
end