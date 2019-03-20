module Cpanet::SharedHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::SessionInitializers
  
  def cpanets    
    Cpanet::Website::Nets.keys.map(&:to_s)
  end
  
  def synchronize_params_filtr
    create_filtrable("synchronize_params")
  end
  
  def synchronize_options
    synchronize_params = session_filtr_params(synchronize_params_filtr) || {}
    
    {
      'clean_cache' => synchronize_params['clean_cache'],
      'show_only_command_keys' => synchronize_params['show_only_command_keys'],
      'calculate_on_background' => synchronize_params['calculate_on_background'],
    }
  end

end
