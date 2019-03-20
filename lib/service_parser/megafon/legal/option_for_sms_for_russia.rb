module ServiceParser
  class Megafon
    class Legal::OptionForSmsForRussia < ServiceParser::Megafon
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        
        case
        when node.text =~ /sms/i; "Опция для #{node.text}";
        else
          ''
        end
      end
    end
    
  end
   
end