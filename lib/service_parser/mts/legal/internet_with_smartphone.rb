module ServiceParser
  class Mts
    class Legal::InternetWithSmartphone < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        node.text =~ /СуперБИТ Smart/ ? 'СуперБИТ Smart' : node.text
      end
    end
    
  end
   
end