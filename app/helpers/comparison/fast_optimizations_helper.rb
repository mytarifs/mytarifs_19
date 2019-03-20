module Comparison::FastOptimizationsHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::SessionInitializers

  def operator
    @operator
  end
  
  def fast_optimization_options_form
    create_filtrable("fast_optimization_options_form")
  end
  
  def fast_optimization_options
    fast_optimization_presenter.options_presentation
  end
  
  def fast_optimization_results(result_type, result_number, tarif_id = nil, tarif_ids_to_limit_result = [])
    raise(StandardError, [
      tarif_ids_to_limit_result,
      session_filtr_params(fast_optimization_options_form)
    ]) if false
    optimization_params = session_filtr_params(fast_optimization_options_form)
    fast_optimization_presenter.result_presentation(optimization_params, result_type, result_number, tarif_id, tarif_ids_to_limit_result)
  end
  
  def calculation_options
    create_filtrable("calculation_options")
  end
  
  def calculation_status
    {
      :stats => Sidekiq::Stats.new.queues, 
      :workers => Sidekiq::Workers.new.map{|process_id, thread_id, work| work['queue'] }, 
    }
  end

  def fast_optimization_presenter
    Comparison::FastOptimizationPresenter.new(:only_own_home_region, m_privacy, m_region)
  end
  
end
