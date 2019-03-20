module ServiceParser
   
  module GeneralHelper
    def squished_node_text(node, only_node_text = false)
      result = []      
      if only_node_text == true
        result << only_node_own_text(node)
      else
        (node.try(:children) || []).each{|child_node| result << child_node.try(:text)}
      end
      result.compact.join(' ').squish
#      only_node_text ? only_node_own_text(node).try(:squish) : node.try(:text).try(:squish)
    end
    
    def only_node_own_text(node)
      node.try(:xpath, 'text()').try(:text)
    end
    
    def text_to_numbers(text)
      return [] if text.blank?
      text.scan(/\d+[,.]?[ ]{0,3}\d*/).map{|t| t.gsub(' ', '').gsub(',', '.').try(:to_f)}
    end
    
    def text_to_formula_params(text, use_day_multiplier = nil)
      return nil if text.blank?
      splitted_by_forward_slash = text.split('/')
      text = splitted_by_forward_slash[1] if splitted_by_forward_slash[1]
      result = text.match(/(\d+\s?\d*)[,.]?[ ]*(\d*)\s*([[:word:]]*)(.*)/i)
      result = splitted_by_forward_slash[0].match(/(\d+\s?\d*)[,.]?[ ]*(\d*)\s*([[:word:]]*)(.*)/i) if splitted_by_forward_slash[1] and (result.nil? or result.size < 2)
      return result if result.nil?
      return result if result.size < 2
      integer_part = try(:normailze_name, result[1])
      decimal_part = try(:normailze_name, result[2]) || 0
      number = "#{integer_part}.#{decimal_part}".to_f
      volume_multiplier = case
      when result[3] =~ /гб|gb/i
        1000.0
      when (result[3] =~ /сек/i or result[4] =~ /сек/i)
        60.0
      else
        1.0
      end
      money_multiplier = case
      when (result[3] =~ /коп/i or result[4] =~ /коп/i)
        1.0/100.0
      else
        1.0
      end
      day_multiplier = case
      when ((use_day_multiplier == 'true') and (result[3] =~ /сут/i or result[4] =~ /сут/i))
        30.0
      else
        1.0
      end
      (number * money_multiplier * volume_multiplier * day_multiplier).try(:round, 2)
    end
    
    def normailze_name(name)
      name.mb_chars.downcase.to_s.gsub(/«|»|\.|[[:space:]]+|-|–/, '')#.gsub('«', '').gsub('»', '').gsub('.', '').gsub('-', '').gsub('–', '')
    end 

    def broad_float_number_regex_string
      '\d+\s?[,|.]?\s?\d*'
    end
    
    def internet_volume_unit_regex_string
      '[м|г|m|g][б|b]'
    end
    
    def month_regex_string
      'месяц|месяч|мес\.'
    end
    
    def day_regex_string
      'сутки|суточ|сут.|сутк.'
    end

  end

end