module ServiceParser
  class Mts
    class Legal::MobileInternet < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        processed_name = node.text.gsub('Интернет-опция ', '')
        "#{processed_name}"
      end
    end
    
  end
   
end