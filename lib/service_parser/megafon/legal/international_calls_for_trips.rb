module ServiceParser
  class Megafon
    class Legal::InternationalCallsForTrips < ServiceParser::Megafon
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        node.text.gsub(' +', '')
      end
    end
    
  end
   
end