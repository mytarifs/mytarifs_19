module ServiceParser
  class Tele2
    class Personal::Option::AddTrafic < ServiceParser::Tele2
      def service_parsing_tags
        internet_volume, volume_units = tarif_class.name.match(/^добавить (?:трафик|скорост[ь|и]) (\d*)\s?([м|г|m|g][б|b])/i)[1..2]
        {
         :base_service_scope => ["div.page_primary"],
         :additional_service_scope => [],
         :service_blocks => [
           {
             :block_tag => [" > div.notesApril > div"],
             :outside_block_name_tag => true,
             :block_name_tag => ["title"],
             :block_name_substitutes_regex => {
               /^(.*добавить )\s?(#{internet_volume})\s?(#{volume_units})\s?(.*)$/i => [1, 2, 3], 
             },
             :block_names_to_exclude => ["wrong_name"],
             
             :sub_block_tag => [],
             :process_sub_block => {},
             :sub_block_name_tag => [],
             :sub_block_name_substitutes => {},
             
             :row_tag => [" > p"],
             :return_row_item_text => true,
             :row_item_text_to_split_by_regex => {
               /^(.*стоимость)(.*)$/i => [1..1, 2..2], 
               /^(.*Объем дополнительного трафика)(.*)$/i => [1..1, 2..2], 
               /^(.*Срок действия)(.*)$/i => [1..1, 2..2], 
               /^(.*Подключить)(.*)$/i => [1..1, 2..2], 
               /^(.*Отключить)(.*)$/i => [1..1, 2..2], 
               /^(.*Проверка статуса услуги)(.*)$/i => [1..1, 2..2], 
               /^(.*добавляет трафик)(.*)$/i => [1..1, 2..2], 
             },
             :param_name_tag => [],
             :param_value_tag => [],
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