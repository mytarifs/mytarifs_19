module ServiceParser
  class Megafon
    class Personal::Option::CallToAllCountries < ServiceParser::Megafon
      def service_parsing_tags
        {
         :base_service_scope => ["div.b-layout-left__wrapper"], #, "div.p-roaming-solution"
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => ["div.b-popular-countries"],
             :block_name_tag => ["h3"],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > ul'],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > li"],
             :param_name_tag => [' > span:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > span:nth-of-type(2)'],
           },

           {
             :block_tag => ["dl.b-accordion__wrap"],
             :block_name_tag => [' > dt.b-accordion__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > dd.b-accordion__content table > tbody' ],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > tr"],
             :param_name_tag => [' > td:nth-of-type(1)'],
             :return_multiple_nodes_for_param_value => true,
             :param_value_tag => [' > td:nth-of-type(2)'],
           },
           {
             :block_tag => ["dl.b-accordion__wrap"],
             :block_name_tag => [' > dt.b-accordion__title'],
             :block_name_substitutes => {},
             
             :sub_block_tag => [' > dd.b-accordion__content > div.b-text'],
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > div.b-text__content"],
             :param_name_tag => [' > p'],
             :param_value_tag => [],
           },
         ]
        }
      end 
    end
  end
end