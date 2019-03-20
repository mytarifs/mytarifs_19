module Cpanet::MyOffers::ProgramsHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::ArrayOfHashable, 
    SavableInSession::Tableable, SavableInSession::SessionInitializers
  include Cpanet::SharedHelper

  def my_offer
    @my_offer
  end
  
  def program
    @program
  end
  
  def program_form
    create_formable(program)
  end    

  def programs_filtr
    create_filtrable("programs")
  end
  
  def programs
    filtr = session_filtr_params(programs_filtr)
    
    model = Cpanet::MyOffer::Program.includes(my_offer: [:website, :offer]) 
    model = model.where(:my_offer_id => params[:my_offer_id]) if !params[:my_offer_id].blank?    
    model = model.where(:status => filtr['status']) if !filtr['status'].blank?    
    
    options = {:base_name => 'programs', :current_id_name => 'program_id', :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_tableable(model, options)
  end
  
  
  
  def check_program_params_before_update
    if !params["cpanet_my_offer_program"].blank?
      params["cpanet_my_offer_program"]['features'] ||= {}
      
      if params["cpanet_my_offer_program"]['features']['page'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('page_param_filtr', 'page_id_filtr', 'page')
      else
        (params["cpanet_my_offer_program"]['features']['page_param_filtr'] || {}).each do |key, value|
          params["cpanet_my_offer_program"]['features']['page_param_filtr'][key] = value - ['']
        end
        (params["cpanet_my_offer_program"]['features']['page_id_filtr'] || {}).each do |key, value|
          params["cpanet_my_offer_program"]['features']['page_id_filtr'][key] = (value - ['']).map(&:to_i)
        end
      end

      params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('stat_id') if params["cpanet_my_offer_program"]['features']['stat_id'].blank?

      if params["cpanet_my_offer_program"]['features']['source_type'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('source_type', 'source_filtr', 'source')
      else
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('source') if params["cpanet_my_offer_program"]['features']['source'].blank?
      end

      if params["cpanet_my_offer_program"]['features']['place_type'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('place_type', 'place')
      else
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('place') if params["cpanet_my_offer_program"]['features']['place'].blank?
      end

      if params["cpanet_my_offer_program"]['features']['place_view_type'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('place_view_type', 'place_view_params')
      else
        if params["cpanet_my_offer_program"]['features']['place_view_params'].blank?
          params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('place_view_params')
        else
          (params["cpanet_my_offer_program"]['features']['place_view_params'] || {}).each do |key, value|
            if value.is_a?(Array)
              params["cpanet_my_offer_program"]['features']['place_view_params'][key] = value - ['']
            else
              params["cpanet_my_offer_program"]['features']['place_view_params'] = 
                params["cpanet_my_offer_program"]['features']['place_view_params'].except(key) if params["cpanet_my_offer_program"]['features']['place_view_params'][key].blank?
            end
          end
        end 
      end
      
      if params["cpanet_my_offer_program"]['features']['catalog'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].
          except('catalog', 'catalog_category_path', 'catalog_category_path_text', 'catalog_category_id_name', 'catalog_category_id_name_text', 
                'catalog_offer_category_name', 'catalog_offer_category_name_text', 'catalog_offer_path', 'catalog_offer_path_text', 
                'catalog_offer_name', 'catalog_offer_name_text', 'catalog_offer_url_name', 'catalog_offer_url_name_text',
                'catalog_category_values', 'catalog_test_path')        
      else
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog') if params["cpanet_my_offer_program"]['features']['catalog'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_category_path') if params["cpanet_my_offer_program"]['features']['catalog_category_path'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_category_path_text') if params["cpanet_my_offer_program"]['features']['catalog_category_path_text'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_category_id_name') if params["cpanet_my_offer_program"]['features']['catalog_category_id_name'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_category_id_name_text') if params["cpanet_my_offer_program"]['features']['catalog_category_id_name_text'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_offer_category_name') if params["cpanet_my_offer_program"]['features']['catalog_offer_category_name'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_offer_category_name_text') if params["cpanet_my_offer_program"]['features']['catalog_offer_category_name_text'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_offer_path') if params["cpanet_my_offer_program"]['features']['catalog_offer_path'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_offer_path_text') if params["cpanet_my_offer_program"]['features']['catalog_offer_path_text'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_offer_name') if params["cpanet_my_offer_program"]['features']['catalog_offer_name'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_offer_name_text') if params["cpanet_my_offer_program"]['features']['catalog_offer_name_text'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_offer_url_name') if params["cpanet_my_offer_program"]['features']['catalog_offer_url_name'].blank?
        params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_offer_url_name_text') if params["cpanet_my_offer_program"]['features']['catalog_offer_url_name_text'].blank?
        
        if params["cpanet_my_offer_program"]['features']['catalog_category_values'].blank?
          params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_category_values')
        else
          params["cpanet_my_offer_program"]['features']['catalog_category_values'] = params["cpanet_my_offer_program"]['features']['catalog_category_values'] - ['']
        end

        if params["cpanet_my_offer_program"]['features']['catalog_offer_values'].blank?
          params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_offer_values')
        else
          params["cpanet_my_offer_program"]['features']['catalog_offer_values'] = params["cpanet_my_offer_program"]['features']['catalog_offer_values'] - ['']
        end
         

        if params["cpanet_my_offer_program"]['features']['catalog_test_path'].blank?
          params["cpanet_my_offer_program"]['features'] = params["cpanet_my_offer_program"]['features'].except('catalog_test_path')
        else
          params["cpanet_my_offer_program"]['features']['catalog_test_path'].each do |key, value|
            params["cpanet_my_offer_program"]['features']['catalog_test_path'] =  params["cpanet_my_offer_program"]['features']['catalog_test_path'].except(key) if value.blank?
          end
        end
      end

    end
    
  end
  
end
