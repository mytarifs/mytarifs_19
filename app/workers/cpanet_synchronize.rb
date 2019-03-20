class CpanetSynchronize < Background::Job::Base
  include Sidekiq::Worker
  sidekiq_options retry: 0, queue: 'worker'

  def initialize(*)
    super
    self.worker_type = 'worker'
  end
  
  def perform(command, options)    
    Cpanet::Runner.send(command, options)
    worker_manager.stop_workers_if_no_new_or_running_jobs(worker_type, min_number)
  end
  
end 
