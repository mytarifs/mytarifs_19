module Background::Job
  class Optimization < Background::Job::Base
    
    def initialize(*)
      super
      self.worker_type = 'tarif_optimization'
    end
    
    def perform
      ::Optimization::Runner.new.calculate_one_tarif(options, operator_id, tarif_id, if_update_call_stat)
    end    

    def queue_name
      worker_type
    end

    def max_attempts
      1
    end
    
    def destroy_failed_jobs
      false
    end

  end
end