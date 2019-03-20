module ServiceParser
  class Tele2
    class Legal::AllTarifs < ServiceParser::Tele2
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        node.at_css("strong.b-tariffs__item__title").try(:text)
      end
    end
    
  end
   
end