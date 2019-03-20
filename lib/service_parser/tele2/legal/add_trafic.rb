module ServiceParser
  class Tele2
    class Legal::AddTrafic < ServiceParser::Tele2
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        "#{base_service_group_name} #{node.text.gsub(' ', '')}"      
      end
      
      def base_service_group_name
        "Добавить трафик"
      end
      
    end
    
  end
   
end