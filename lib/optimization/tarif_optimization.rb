module Optimization
  class TarifOptimization11111# < ActiveJob::Base
    include Sidekiq::Worker
  #  @queue = :tarif_optimization
  
    def self.perform1(repo_id, operator_id, tarif_id, if_update_call_stat)
      repo = ::Optimization::Repository.find(repo_id)
      repo.calculate_tarif_cost_by_tarif(operator_id, tarif_id, if_update_call_stat)
    end
  
    def self.perform2(options, operator_id, tarif_id, if_update_call_stat)
      Optimization::Optimizator.new(options).calculate_tarif_cost_by_tarif(operator_id, tarif_id, if_update_call_stat)
    end
  
    def perform(options, operator_id, tarif_id, if_update_call_stat)
      Optimization::Optimizator.new(options).calculate_tarif_cost_by_tarif(operator_id, tarif_id, if_update_call_stat)
    end
  end
end