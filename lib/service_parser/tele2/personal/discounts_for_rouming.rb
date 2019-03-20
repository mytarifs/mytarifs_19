module ServiceParser
  class Tele2
    class Personal::DiscountsForRouming < ServiceParser::Tele2
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        node.at_css("strong.b-services__item__title").try(:text)
      end
    end
    
  end
   
end