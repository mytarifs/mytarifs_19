module ServiceParser
  class Mts
    class Personal::MobileInternet < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        ['Подробнее', 'подробнее'].include?(node.text) ? "Единый интернет" : node.text
      end
    end
    
  end
   
end