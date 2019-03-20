module Cpanet::WebsitesHelper
  include SavableInSession::Filtrable, SavableInSession::Tableable, SavableInSession::SessionInitializers
  include Cpanet::SharedHelper
  
  def cpanets    
    Cpanet::Website::Nets.keys.map(&:to_s)
  end
  
  def websites_filtr
    create_filtrable("websites")
  end
  
  def websites
    filtr = session_filtr_params(websites_filtr)
    
    model = Cpanet::Website.where('true')
    model = model.where(:cpanet => filtr['cpanet']) if !filtr['cpanet'].blank?

    options = {:base_name => 'websites', :current_id_name => 'website_id', :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_tableable(model, options)
  end

  def synchronize_websites
    filtr = session_filtr_params(websites_filtr) || {}    
    
    cpanets_to_update = filtr['cpanet'].blank? ? cpanets : [filtr['cpanet']]
    
    cpanets_to_update.each do |cpanet_to_update|
      options = {
        'cpanet' => cpanet_to_update,
      }.deep_merge(synchronize_options)

      cpanet = Cpanet::Runner.init(options)
      websites_from_net = cpanet.websites
      
      return {:alert => "error in #{cpanet_to_update}, #{websites_from_net}" } if cpanet.processed_result_has_error?(websites_from_net)

      Cpanet::Website.synchronize_websites(cpanet_to_update, websites_from_net)
    end
    
    {:notice => "Websites have been synchronizied for #{cpanets_to_update}" }
  end

end
