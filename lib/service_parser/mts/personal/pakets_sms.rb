module ServiceParser
  class Mts
    class Personal::PaketsSms < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        case key
        when "1"
          if node.text =~ /SMS\./
            "Пакет #{node.text.gsub(/[[:space:]]+/, '').gsub('Пакет ', '')}"
          else
            ''
          end 
        when "2"
          "Пакет #{node.text.gsub('Пакет ', '')}"
        when "3"
          paket_size = node.text.scan(/\d+/)[0]
          return paket_size if paket_size.blank?
          "SMS пакет #{paket_size}"
        else
          "Пакет #{node.text}"
        end
#        paket_size = node.text.scan(/\d+/)[0]
#        return paket_size if paket_size.blank?              
      end
    end
    
  end
   
end