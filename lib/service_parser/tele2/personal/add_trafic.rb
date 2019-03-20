module ServiceParser
  class Tele2
    class Personal::AddTrafic < ServiceParser::Tele2
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        scanned_text = node.text.match(/^(.*)\s([\d]*\s[г|м][б])(.*)$/i)
        internet_volume = scanned_text[2] ? scanned_text[2] : "To add"
        "#{base_service_group_name} #{internet_volume}"      
      end
      
      def base_service_group_name
        "Добавить трафик"
      end
      
    end
    
  end
   
end