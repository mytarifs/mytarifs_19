module ServiceParser
  class Mts
    class Legal::PaketsBusiness < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        "Бизнес пакет #{node.text}"
      end
    end
    
  end
   
end