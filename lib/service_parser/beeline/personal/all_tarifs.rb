module ServiceParser
  class Beeline
    class Personal::AllTarifs < ServiceParser::Beeline
      def service_name_from_node(node, key = nil)
        return "type: #{node.type}" if node.text.blank?# or node.try(:[], 'href').blank?
        puts node.to_s
        case key
        when '1'
          node.at_css("span[class*=ProductsFamily_linkText]").text
        else
          case
          when node.text =~ /Совсем Всё\. Постоплата/i; "Совсем Всё (постоплатный)"
          else
            node.try(:text)
          end
        end
      end

      def service_url(node, key = nil)
        case key
        when '1'
          text = node.at_css("span[class*=ProductsFamily_linkText]").text
          if text == 'Всёшечка'
            "/customers/products/mobile/tariffs/details/vseshechka-new/"
          else
            "/customers/products/mobile/tariffs/details/vse-#{vse_number_part(text)}/"
          end
        else
          node['href']
        end          
      end
      
      def vse_number_part(text)
        text.split(' ')[1].try(:to_i)
      end
      
      def no_link_from_node(key)
        case key
        when '1'
          false
        else
          true
        end
      end

    end
    
  end
   
end