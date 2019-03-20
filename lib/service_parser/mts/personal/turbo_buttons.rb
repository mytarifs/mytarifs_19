module ServiceParser
  class Mts
    class Personal::TurboButtons < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        "#{base_service_group_name} #{node.text}"      
      end
      
      def base_service_group_name
        "Турбо-кнопка"
      end
      
    end
    
  end
   
end