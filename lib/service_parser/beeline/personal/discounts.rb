module ServiceParser
  class Beeline
    class Personal::Discounts < ServiceParser::Beeline
      def service_name_from_node(node, key = nil)
        return "type: #{node.type}" if node.text.blank? or node.try(:[], 'href').blank?
        case
        when node.try(:[], 'href') =~ /besplatno/; ''
        when (node.try(:[], 'href') =~ /paket-interneta/ and node.text =~ /гб|мб/i)
          paket_size = node.text.scan(/\d+/)[0]
          paket_size_type = node.text.scan(/гб|мб/i)[0]
          "Пакет интернета #{paket_size} #{paket_size_type}"
        when (node.try(:[], 'href') =~ /highway|hayvey/ and node.text =~ /гб|мб/i and !(node.try(:[], 'href') =~ /sutki|post/) )
          paket_size = node.text.scan(/\d+\,*\d*/)[0]
          paket_size_type = node.text.scan(/гб|мб/i)[0]
          "Хайвей #{paket_size} #{paket_size_type}"
        when (node.try(:[], 'href') =~ /highway|hayvey/ and node.text =~ /гб|мб/i and (node.try(:[], 'href') =~ /post/) )
          paket_size = node.text.scan(/\d+\,*\d*/)[0]
          paket_size_type = node.text.scan(/гб|мб/i)[0]
          "Хайвей #{paket_size} #{paket_size_type} (постоплатный)"
        when (node.try(:[], 'href') =~ /highway|hayvey/ and node.text =~ /гб|мб/i and (node.try(:[], 'href') =~ /sutki/) )
          paket_size = node.text.scan(/\d+\,*\d*/)[0]
          paket_size_type = node.text.scan(/гб|мб/i)[0]
          "Хайвей #{paket_size} #{paket_size_type} (оплата в сутки)"
        when node.text =~ /7 дней|30 дней/ #node.try(:[], 'href') =~ /7-dney|30-dney/
          "#{node.text} интернета для путешествий по России"
        else
          node.text
        end
      end

    end
    
  end

end 