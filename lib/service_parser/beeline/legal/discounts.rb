module ServiceParser
  class Beeline
    class Legal::Discounts < ServiceParser::Beeline
      def service_name_from_node(node, key = nil)
        return "type: #{node.type}" if node.text.blank? or node.try(:[], 'href').blank?
        node.text
      end

    end
    
  end

end 