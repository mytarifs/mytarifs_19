module ServiceParser
  class Megafon
    class Personal::OptionsForSms < ServiceParser::Megafon
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        "Опция для #{node.text}"
      end
    end
    
  end
   
end