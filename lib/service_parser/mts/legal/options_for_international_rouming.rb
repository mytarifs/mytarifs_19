module ServiceParser
  class Mts
    class Legal::OptionsForInternationalRouming < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        ['SMS-пакеты', 'Интернет-пакеты'].include?(node.text) ? "#{node.text} за границей" : node.text
      end
    end
    
  end
   
end