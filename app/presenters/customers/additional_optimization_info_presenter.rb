class Customers::AdditionalOptimizationInfoPresenter #ServiceHelper::AdditionalOptimizationInfoPresenter
  attr_reader :user_id, :demo_result_id
  
  def initialize(options = {})
    @user_id = options[:user_id] || 0
    @demo_result_id = options[:demo_result_id]
  end
  
  def performance_results
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'minor_results',
      :demo_result_id => demo_result_id,
      :user_id => user_id,
    }, 'performance_results') || [{}]
  end
  
  def service_packs_by_parts_array #(new, for tarif_set)
    result = []
    service_packs_by_parts.each do |tarif, services_by_tarif|
      temp_result = {:tarif => tarif}
      services_by_tarif.each do |part, services|
        temp_result.merge!({part => services.size})
#        temp_result.merge!({part => services.keys.size})
      end
      result << temp_result
    end if service_packs_by_parts
    result
  end
  
  def service_packs_by_parts
    Customer::Stat.get_named_results({
      :result_type => 'optimization_results',
      :result_name => 'minor_results',
      :demo_result_id => demo_result_id,
      :user_id => user_id,
    }, 'service_packs_by_parts') 
  end
  
end
