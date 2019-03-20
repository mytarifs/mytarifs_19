module ServiceParser
  class Tele2
    class Personal::Option::PaketOfInternet < ServiceParser::Tele2
      def service_parsing_tags
        {
         :base_service_scope => ["div.page_primary"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.notesApril", " > div.b-openable > div"],
             :block_name_tag => ["h2"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [],
             :process_sub_block => {},
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p", ],
             :return_row_item_text => true,
             :row_item_text_to_split_by_regex => {
               /^(При подключении услуги предоставляется)\s*(\d*\s?[м|г]б)(.*)([\.|,]{1,2})(.*)$/i => [1..1, 2..2], 
               /^(При подключении услуги без ограничения скорости предоставляется)\s*(\d*\s?[м|г]б)(.*)([\.|,]{1,2})(.*)$/i => [1..1, 2..2], 
               /^(Абонентская плата[-]?)\s*(\d*)(.*)$/i => [1..1, 2..2], 
               /^(.*)[-|–|-|—](.*)$/i => [1..1, 2..2], 
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