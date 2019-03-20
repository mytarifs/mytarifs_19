class SideTarifOptimization < Background::Job::Base
  include Sidekiq::Worker
  sidekiq_options retry: 0, queue: 'worker'

  def initialize(*)
    super
    self.worker_type = 'worker'
  end
  
  def perform(options, operator_id, tarif_id, if_update_call_stat)    
    Optimization::Runner.new.calculate_one_tarif(options, operator_id, tarif_id, if_update_call_stat)
    worker_manager.stop_workers_if_no_new_or_running_jobs(worker_type, min_number)
  end
  
  def self.is_side_calculating_rating(job_type = "tarif_optimization")
    result = false
    queue = Sidekiq::Queue.new("worker")
    queue.each do |job|
      raise(StandardError, [
        job.args[0],#.try(:[], :background_job_type)
        job.args[0].try(:[], "background_job_type")
      ]) if false
      if job.args[0].try(:[], "background_job_type") == job_type
        result = true
        break 
      end
    end
    result
  end
end 
