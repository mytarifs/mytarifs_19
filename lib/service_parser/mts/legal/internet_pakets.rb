module ServiceParser
  class Mts
    class Legal::InternetPakets < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        td_texts = (node.children || []).map{|td| td.text }[0..1]
        case key
        when "1"
          "Интернет пакет для путешествий по Европе и странам МТС #{td_texts.join(' ')}"
        when "2"
          "Интернет пакет для путешествий по всем странам мира #{td_texts.join(' ')}"
        end
      end
    end
    
  end
   
end