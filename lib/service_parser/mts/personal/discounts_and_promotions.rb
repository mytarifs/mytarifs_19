module ServiceParser
  class Mts
    class Personal::DiscountsAndPromotions < ServiceParser::Mts
      def service_name_from_node(node, key = nil)
        return node.text if node.text.blank?
        case node.text
        when "Тарифная опция \"Область\""; 'Область';
        else
          node.text
        end
      end

    end
    
  end
   
end