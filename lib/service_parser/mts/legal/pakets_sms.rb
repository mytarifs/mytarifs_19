module ServiceParser
  class Mts
    class Legal::PaketsSms < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        "Пакет #{node.text}"
      end
    end
    
  end
   
end