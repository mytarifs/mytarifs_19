module ServiceParser
  class Beeline
    class Legal::SvoyaSetPostoplata < ServiceParser::Beeline
      def service_name_from_node(node, key = nil)
        return "type: #{node.type}" if node.text.blank?
        case
        when node.text =~ /«Своя сеть местная»/i
          "«Своя сеть местная»"
        when node.text =~ /«Своя сеть местная \+ МГ»/i
          "«Своя сеть местная + МГ»"
        else
          node.text
        end
      end

    end
    
  end

end 