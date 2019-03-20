module ServiceParser
  class Megafon
    class Legal::DiscountsAndPromotions < ServiceParser::Megafon
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        node.at_css("div.b-b2b-toption-row__type > h4").try(:text)
      end

      def service_url(node, key = nil)
        node.at_css("a").try(:[], 'href')
      end
      
    end
    
  end
   
end