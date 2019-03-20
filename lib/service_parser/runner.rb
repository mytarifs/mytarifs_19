module ServiceParser
   
  class Runner
    def self.init(options)
      base_class_name = base_class_string(options[:operator_id])
      class_name = if !['true', true].include?(options[:tarif_class].try(:for_parsing))
        parsing_class = options[:parsing_class] || "Base"
        tarif_class_string(base_class_name, options[:tarif_class], parsing_class)
      else
        options[:parsing_class].blank? ? base_class_name : "#{base_class_name}::#{options[:parsing_class]}"
      end
      class_name.constantize.new(options)
    end
    
    def self.base_class_string(operator_id)
      case operator_id
      when Category::Operator::Const::Tele2; "ServiceParser::Tele2";
      when Category::Operator::Const::Beeline;  "ServiceParser::Beeline";
      when Category::Operator::Const::Megafon; "ServiceParser::Megafon";
      when Category::Operator::Const::Mts;  "ServiceParser::Mts";
      else
      end
    end
    
    def self.tarif_class_string(base_class_name, tarif_class, parsing_class)
      result = base_class_name
      return result if tarif_class.blank?
      privacy_part = tarif_class.privacy_id == 1 ? "Legal" : "Personal"
      standard_service_part = case tarif_class.standard_service_id
      when TarifClass::ServiceType[:tarif]; 'Tarif'
      when TarifClass::ServiceType[:common_service]; 'Common'
      else 'Option'
      end
      "#{base_class_name}::#{privacy_part}::#{standard_service_part}::#{parsing_class}"
    end

  end

end