class ScrapServiceGroup < Background::Job::Base
  include Sidekiq::Worker
  sidekiq_options retry: 0, queue: 'worker'

  def initialize(*)
    super
    self.worker_type = 'worker'
  end
  
  def perform(region_id, operator_id, privacy_id, standard_service_id, options)
    Scraper::Service.run_scraper_for_region_operator_privacy_standard_service_group(region_id, operator_id, privacy_id, standard_service_id, options)    
    worker_manager.stop_workers_if_no_new_or_running_jobs(worker_type, min_number)
  end
  
  def self.is_side_calculating_rating(job_type = "scrap_service_group")
    result = false
    queue = Sidekiq::Queue.new("worker")
    queue.each do |job|
      if job.args[0].try(:[], "scrap_service_group") == job_type
        result = true
        break 
      end
    end
    result
  end
end 
