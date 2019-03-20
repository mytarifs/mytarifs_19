module Optimization::Global
  module TarifCorrectnessTester
    module ClassMethods
      def check_params_in_tarifs
        result = []
        t = []
        Service::CategoryGroup.joins(price_lists: [formulas: :standard_formula]).
          select("distinct service_category_groups.tarif_class_id, (price_formulas.formula->'params')::jsonb as price_params, price_standard_formulas.stat_params").each do |item|
            new_result = [(item.price_params.keys - ["price", "price_0", "price_1", "price_2"]).sort, item.stat_params.keys.sort]
            next if new_result[0].blank?
            result << new_result
            t << item.tarif_class_id if new_result == [["max_duration_minute"], ["sum_volume"]]
          end
          result.uniq.each{|r| puts r.to_s}
          t
      end
    end
  end  
end
