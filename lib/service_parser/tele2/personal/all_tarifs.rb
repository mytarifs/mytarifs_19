module ServiceParser
  class Tele2
    class Personal::AllTarifs < ServiceParser::Tele2
      def service_name_from_node(node, key = nil)
        puts node
        puts key
        raise(StandardError) if false
        return node.text if node.text.blank?
        node.at_css("td.services-td > span.title").try(:text)
      end

      def service_url(node, key = nil)
        node.at_css("a:contains('О тарифе')").try(:[], 'href')
      end
    end
    
  end
   
end