module Optimization::Global
  class Test < Optimization::Global::Base
    def run_tests
      test_if_global_count_gets_all_customer_calls
      test
      test_for_specific_global_category
    end
    
    def test_if_global_count_gets_all_customer_calls
      result = {}; s = 0
      calls = Customer::Call.where(:call_run_id => 553)
      stat_params = ["count(*) as call_id_count"]
      Customer::Call.find_by_sql(stat_by_all_global_categories_sql(calls, stat_params, false)).
      map{|r| result[r['global_name']] = (result[r['global_name']] || 0) + r['call_id_count']; s += r['call_id_count']}
      [result, s]
    end
    
    def test
      Service::CategoryTarifClass.select("count(*) as count", :uniq_service_category, :filtr).where.not(:filtr => nil).
        group(:uniq_service_category, :filtr).map{|c| c['count']}.sum#.distinct([:uniq_service_category, :filtr])
    end
    
    def test_for_specific_global_category
      result = []
      calls = Customer::Call.where(:call_run_id => 553)
      stat_params = ["count(*) as call_id_count"]
      params = [:own_and_home_regions, :calls_out, :to_own_and_home_regions]
      Customer::Call.find_by_sql(stat_by_one_category_sql(calls, stat_params, params)).
      map{|r| result << r.attributes}
      [result, result.size]
    end
  end  
end
