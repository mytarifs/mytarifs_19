class SideFastOptimizationDataLoader < Background::Job::Base
  include Sidekiq::Worker
  sidekiq_options retry: 0, queue: 'worker'

  def initialize(*)
    super
    self.worker_type = 'worker'
  end
  
  def perform(method_name, operators_to_calculate = [])    
    FastOptimization::DataLoader.new.calculation_runner(method_name, operators_to_calculate)
#    worker_manager.stop_workers_if_no_new_or_running_jobs(worker_type, min_number)
  end
end 
