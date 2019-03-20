module ServiceParser
  class Megafon
    class Legal::OptionsForTravelOnWorld < ServiceParser::Megafon
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        node.at_css("dl dt").try(:text).try(:gsub, ' +', '').try(:gsub, ' +', '').try(:gsub, '+', '')
      end
    end
    
  end
   
end