module ServiceParser
  class Tele2
    class Personal::SmsAndMms < ServiceParser::Tele2
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        node.at_css("strong.b-services__item__title").try(:text).try(:gsub, 'c', 'с')
      end
    end
    
  end
   
end