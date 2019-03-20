module ServiceParser
  class Megafon
    class Personal::OptionsForCallsAndSms < ServiceParser::Megafon
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        service_name = node.at_css("h4.b-text__title").try(:text)
        service_name =~ /^SMS [S|L|M|XL]/ ? "Опция для #{service_name}" : service_name
      end
    end
    
  end
   
end