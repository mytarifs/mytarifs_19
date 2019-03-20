module Cpanet::MyOffersHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::ArrayOfHashable, 
    SavableInSession::Tableable, SavableInSession::SessionInitializers
  include Cpanet::SharedHelper
  
  def my_offer
    @my_offer
  end

  def my_offer_form
    create_formable(my_offer)
  end    

  def my_offers_filtr
    create_filtrable("my_offers")
  end
  
  def my_offers
    filtr = session_filtr_params(my_offers_filtr)
    my_offers_status = ((filtr['my_offers_status'] || []) - [''])
    offers_status = ((filtr['offers_status'] || []) - [''])
    
    model = Cpanet::MyOffer.includes(:website, :offer).joins(:website).where('true')
    model = model.where(:cpanet_websites => {:cpanet => filtr['cpanet']}) if !filtr['cpanet'].blank?
    model = model.where(:website_id => filtr['website_id'].try(:to_i)) if !filtr['website_id'].blank?
    model = model.where(:offer_id => filtr['offer_id'].try(:to_i)) if !filtr['offer_id'].blank?
    model = model.where(:status => my_offers_status) if !my_offers_status.blank?
    model = model.joins(:offer).where(:cpanet_offers => {:status => offers_status}) if !offers_status.blank?

    options = {:base_name => 'my_offers', :current_id_name => 'my_offer_id', :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_tableable(model, options)
  end

  def my_offer_catalogs
    filtr = session_filtr_params(my_offers_filtr)
    
    my_offer_id = session[:current_id].try(:[], 'my_offer_id').try(:to_i)
    
    catalogs = Cpanet::MyOffer.where(:id => my_offer_id).first.try(:catalogs) || {}
    hash_model = []
    catalogs.each{|key, catalog| hash_model << catalog }

    hash_model.sort_by!{|h| h["yml_name"]}
    
    options = {:base_name => 'my_offer_catalogs', :current_id_name => 'my_offer_catalog_id', :id_name => 'yml_name',:pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_array_of_hashable(hash_model, options)
  end

  def check_my_offer_params_before_update
    if !params["cpanet_my_offer"].blank?
      params["cpanet_my_offer"]['website_id'] = params["cpanet_my_offer"]['website_id'].to_i if !params["cpanet_my_offer"]['website_id'].blank?
      params["cpanet_my_offer"]['features'] ||= {}
    end
    
  end


  def synchronize_my_offers
    filtr = session_filtr_params(my_offers_filtr) || {}    
    
    cpanets_to_update = filtr['cpanet'].blank? ? cpanets : [filtr['cpanet']]    
    
    cpanets_to_update.each do |cpanet_to_update|
      
      website_ids_to_update = filtr['website_id'].blank? ? Cpanet::Website.where(:cpanet => cpanet_to_update).pluck(:id).uniq : [filtr['website_id'].try(:to_i)]
      website_ids_to_update.each do |website_id_to_update|
        options = {
          'cpanet' => cpanet_to_update,
          'website_id' => website_id_to_update,
        }.deep_merge(synchronize_options)
  
        Cpanet::Runner.run_command_with_background(:synchronize_my_offer, options)
      end
    end
    
    {:notice => "MyOffers have been synchronizied for #{cpanets_to_update}" }
  end

  def synchronize_offers_helper
    filtr = session_filtr_params(my_offers_filtr) || {}    
    
    cpanets_to_update = filtr['cpanet'].blank? ? cpanets : [filtr['cpanet']]    
    
    cpanets_to_update.each do |cpanet_to_update|
      
      website_ids_to_update = filtr['website_id'].blank? ? Cpanet::Website.where(:cpanet => cpanet_to_update).pluck(:id).uniq : [filtr['website_id'].try(:to_i)]
      website_ids_to_update.each do |website_id_to_update|
        offer_ids_to_update = filtr['offer_id'].blank? ? Cpanet::MyOffer.where(:website_id => website_id_to_update).pluck(:offer_id).uniq : [filtr['offer_id'].try(:to_i)]
        offer_ids_to_update.each do |offer_id_to_update|
          options = {
            'cpanet' => cpanet_to_update,
            'website_id' => website_id_to_update,
            'offer_id' => offer_id_to_update,
          }.deep_merge(synchronize_options)
          
          Cpanet::Runner.run_command_with_background(:synchronize_offer, options)
        end
      end
    end
    
    {:notice => "MyOffers have been synchronizied for #{cpanets_to_update}" }
  end
  
  def synchronize_catalogs_helper
    filtr = session_filtr_params(my_offers_filtr) || {}    
    
    cpanets_to_update = filtr['cpanet'].blank? ? cpanets : [filtr['cpanet']]    
    cpanets_to_update.each do |cpanet_to_update|
      
      website_ids_to_update = filtr['website_id'].blank? ? Cpanet::Website.where(:cpanet => cpanet_to_update).pluck(:id).uniq : [filtr['website_id'].try(:to_i)]
      website_ids_to_update.each do |website_id_to_update|

        my_offers_to_update = Cpanet::MyOffer.where(:website_id => website_id_to_update)
        my_offers_to_update = my_offers_to_update.joins(:offer).where(:cpanet_offers => {:id => filtr['offer_id'].try(:to_i)}) if !filtr['offer_id'].blank? 

        my_offers_to_update.each do |my_offer_to_update|
          options = {
            'cpanet' => cpanet_to_update,
            'website_id' => website_id_to_update,
            'offer_id' => my_offer_to_update.offer.try(:id),
            'my_offer_id' => my_offer_to_update.try(:id),
          }.deep_merge(synchronize_options)
          
          Cpanet::Runner.run_command_with_background(:synchronize_catalog, options)
        end
      end
    end
    
    {:notice => "MyOffers have been synchronizied for #{cpanets_to_update}" }
  end

end
