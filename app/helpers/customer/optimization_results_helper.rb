module Customer::OptimizationResultsHelper
  include SavableInSession::ArrayOfHashable, SavableInSession::SessionInitializers

  def performance_results
    options = {:base_name => 'performace_results', :current_id_name => 'check_point', :id_name => 'check_point', :pagination_per_page => 50}
    create_array_of_hashable(minor_result_presenter.performance_results, options)
  end
  
  def service_packs_by_parts
    options = {:base_name => 'service_packs_by_parts', :current_id_name => 'tarif', :id_name => 'tarif', :pagination_per_page => 10}
    create_array_of_hashable(minor_result_presenter.service_packs_by_parts_array, options)
  end

  def minor_result_presenter
#    @minor_result_presenter ||= 
    Customers::AdditionalOptimizationInfoPresenter.new({:user_id=> current_or_guest_user_id })
  end   
  
end
