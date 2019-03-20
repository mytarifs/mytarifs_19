module ServiceParser
  class Megafon
    class Legal::OptionsForSmsAndMms < ServiceParser::Megafon
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        case
        when node['href'] =~ /sms_options/i; "Опции для SMS для России";
        else
          node.text
        end
      end
    end
    
  end
   
end