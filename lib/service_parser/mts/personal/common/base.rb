module ServiceParser
  class Mts
    class Personal::Common::Base < ServiceParser::Mts
      def service_parsing_tags
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
             
             :sub_block_tag => ["> div.FederalHolderMarker:nth-of-type(1)"],
             :sub_block_name_tag => [],
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
             :row_item_text_to_split_by_regex => {
               /(Безлимитные звонки)\s*(.*)/i => [1..2, 1..1], 
               /(Безлимитный интернет)\s*(.*)/i => [1..2, 1..1], 
               /(\d+\s*рублей)?\s*(за входящие звонки в (?:поездках по миру|международном роуминге))\s*(.*)/i => [1..2, 3..3], 
               /(\d+)\s*(мин\S*)\s*(.*)/i => [2..3, 1..2], 
               /(\d+)\s*([МГ]б)\s*(.*)/i => [2..3, 1..2], 
               /(\d+)\s*((?:sms|смс))\s*(.*)/i => [2..3, 1..2], 
               /((?:.*тариф действует|.*действует на территории))\s*(.*)/i => [1..2, 1..1], 
               /(при подключении новых номеров)\s*(.*)/i => [1..1, 2..2], 
             },
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