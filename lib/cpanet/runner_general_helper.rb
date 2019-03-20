module Cpanet
  module RunnerGeneralHelper

    def start_background_workers(options, number_of_workers_to_add)
      worker_name = "worker"
      
      begin
        base_worker_add_number = 1
        number_of_workers_to_add = [
          base_worker_add_number - Background::WorkerManager::Manager.worker_quantity(worker_name),
          number_of_workers_to_add
        ].min
#        Background::WorkerManager::Manager.start_number_of_worker(worker_name, number_of_workers_to_add)
      rescue => e
        raise(StandardError, e)
      end        
    end
 
    def my_deep_symbolize!(hash)
      hash.deep_transform_keys! do |key| 
        begin
          Integer(key) 
        rescue 
          key.to_sym 
        rescue 
          key
        end
      end 
      hash
    end
  end  
end
