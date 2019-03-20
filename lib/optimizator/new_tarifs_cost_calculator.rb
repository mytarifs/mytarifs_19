module Optimizator
  class NewTarifsCostCalculator
    
    attr_reader :tarif_list_generator, :tarif_results
    
    def initialize(tarif_list_generator, performance_checker)
      @tarif_list_generator = tarif_list_generator
      @tarif_results = {}
      @performance_checker = performance_checker
    end
    
    def calculate_calls_by_category_groups(calls)
      tarif_list_generator.all_services.each do |service|
        
      end
    end
    
    def init_tarif_cost_calculator_stat(options)
      service_ids = tarif_list_generator.all_services
      call_run_id = options[:user_input][:call_run_id]
      accounting_period = options[:user_input][:accounting_period]
      calls = Customer::Call.base_customer_call_sql(call_run_id, accounting_period)

      global_stater = ::Optimizator::Global::NewStat.new(options)
      @global_stat = global_stater.calls_by_category_groups(calls, service_ids)
      raise(StandardError)
    end
    
  end  
end
