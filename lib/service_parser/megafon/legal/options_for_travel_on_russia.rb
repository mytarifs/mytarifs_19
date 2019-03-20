module ServiceParser
  class Megafon
    class Legal::OptionsForTravelOnRussia < ServiceParser::Megafon
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        node.at_css("dl dt").try(:text)
      end
    end
    
  end
   
end