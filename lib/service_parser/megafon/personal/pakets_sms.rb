module ServiceParser
  class Megafon
    class Personal::PaketsSms < ServiceParser::Megafon
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        name_parts = node.css("td").map(&:text)[0..1]
        name_parts[1] = "Весь мир" if name_parts[1] =~ /мир/i
        name_parts.join(" ")
      end
    end
    
  end
   
end