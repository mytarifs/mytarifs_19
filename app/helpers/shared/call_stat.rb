module Shared::CallStat
  include SavableInSession::Filtrable, SavableInSession::ArrayOfHashable, SavableInSession::SessionInitializers

  def calls_stat_options
    create_filtrable("calls_stat_options")
  end

  def calls_stat
    filtr = session_filtr_params(calls_stat_options)
    calls_stat_options = filtr.keys.map{|key| key if filtr[key] == 'true'}
    calls_stat_options = {"rouming" => 'true', "service" => 'true'} if calls_stat_options.blank?
    accounting_period = filtr["accounting_period"]
        
    options = {:base_name => 'calls_stat', :current_id_name => 'calls_stat_category', :id_name => 'calls_stat_category', :pagination_per_page => 100}
    call_run_array = call_run ? call_run.calls_stat_array(calls_stat_options, accounting_period) : [{}]
#    @calls_stat ||= 
    create_array_of_hashable(call_run_array, options )
  end

end
