module ServiceParser
  class Mts
    class Legal::PaketsForEveryone < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        case key
        when "1"
          "Пакет «Минуты для ВСЕХ» #{node.text}" 
        when "2"
          "Пакет «SMS для ВСЕХ» #{node.text}" 
        when "3"
          "Пакет «Интернет для ВСЕХ» #{node.text}" 
        when "4"
          "Пакет «Межгород для ВСЕХ» #{node.text}" 
        else
          "Пакет #{node.text}"
        end
#        paket_size = node.text.scan(/\d+/)[0]
#        return paket_size if paket_size.blank?              
      end
    end
    
  end
   
end