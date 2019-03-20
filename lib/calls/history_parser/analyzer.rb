module Calls::HistoryParser
  class Analyzer
    def self.find_user_info(call_run_id)
      phone_number_counter = {}
      Customer::Call.where(:call_run_id => call_run_id, :base_service_id => 50).find_each(:batch_size => 10) do |call|
        phone_number_counter[call] = 0
        
      end
    end
  end

end
