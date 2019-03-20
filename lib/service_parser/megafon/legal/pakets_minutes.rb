module ServiceParser
  class Megafon
    class Legal::PaketsMinutes < ServiceParser::Megafon
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        name_parts = node.css("td").map(&:text)[0..1]
        name_parts[0] = name_parts[0].try(:scan, /\d+/i).try(:[], 0)
        "Пакеты минут #{name_parts[0]} #{name_parts[1]}"
#        name_parts.join(' ')
      end
    end
    
  end
   
end