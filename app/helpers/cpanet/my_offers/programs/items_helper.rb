module Cpanet::MyOffers::Programs::ItemsHelper
  include SavableInSession::Filtrable, SavableInSession::Formable, SavableInSession::ArrayOfHashable, 
    SavableInSession::Tableable, SavableInSession::SessionInitializers
  include Cpanet::SharedHelper

  def program
    @program || Cpanet::MyOffer::Program.where(:id => item.program_id).first
  end
  
  def item
    @item
  end
  
  def item_form
    create_formable(item)
  end    

  def items_filtr
    create_filtrable("items")
  end
  
  def items
    filtr = session_filtr_params(items_filtr)

    model = Cpanet::MyOffer::Program::Item.includes(:program).where('true')
    model = model.where(:program_id => params[:program_id]) if !params[:program_id].blank? 
    model = model.where(:status => filtr['status']) if !filtr['status'].blank?    
    
    options = {:base_name => 'items', :current_id_name => 'item_id', :pagination_per_page => (filtr['row_per_page'].try(:to_i) || 25)}
    create_tableable(model, options)
  end
  
  def load_deeplinks_from_catalog
    filtr = session_filtr_params(items_filtr)
    
    domain = filtr['domain']
    return {:notice => "no domain chosen"} if domain.blank?
    
    my_offer = program.my_offer
    website = my_offer.website
    cpanet = website.cpanet
    case cpanet
    when 'admitad'
    when 'actionpay'
      catalog_name = program.catalog
      return {:notice => "no catalog"} if catalog_name.blank?
      
      yml_id = my_offer.catalogs[catalog_name].try(:[], 'yml_id')
      return {:notice => "noyml_idcatalog"} if yml_id.blank?
      
      options = {
        'clean_cache' => 'false',
        'run_command_without_processing' => 'true',
        'cpanet' => cpanet,
        'website_id' => website.id,
        'yml' => yml_id,
        'act' => 'deeplinks',
        'domain' => domain,
      }
      cpanet = Cpanet::Runner.init(options)
      
      catalog_with_deeplinks = cpanet.catalog_with_deeplinks
      doc = Nokogiri::XML(catalog_with_deeplinks)
      
      catalog_offer_values = program.catalog_offer_values
      catalog_offer_id_nodes = doc.search("//yml-catalog/shop/offers/offer/offer/id").select{|s| catalog_offer_values.include?(s.text) }
      catalog_offer_nodes = catalog_offer_id_nodes.map{|catalog_offer_id_node| catalog_offer_id_node.parent}

      catalog_offer_nodes.each do |catalog_offer_node|
        catalog_offer_node_attrs = catalog_offer_node.elements.map(&:name)
        item_features = {}
        catalog_offer_node_attrs.each do |catalog_offer_node_attr|
          item_features[catalog_offer_node_attr] = catalog_offer_node.at_css("#{catalog_offer_node_attr}").text
        end

        item_to_update = Cpanet::MyOffer::Program::Item.find_or_create_by(:program_id => program.id, :name => item_features['model'])
        
        choosen_page_item_filtr_item = Cpanet::PageType.page_item_filtr(program.page, program.page_param_filtr, program.page_id_filtr).
          select do |page_item_filtr_item| 
            if page_item_filtr_item[0].split(' ').size > 1
              item_features['model'] =~ /#{page_item_filtr_item[0]}/i
            else
              item_features['model'] == page_item_filtr_item[0]
            end
            
          end[0]

        page_item_id = choosen_page_item_filtr_item.try(:[], 1)
        page_item_name_for_check = choosen_page_item_filtr_item.try(:[], 0)

        features = {
          :page_item => page_item_id,
          :page_item_name_for_check => page_item_name_for_check,
          :source => item_features['url'],
          :content_name => "Подключить #{item_features['model']} у оператора",
          :content_desc => item_features,
        }
          
        item_to_update.update({
          :status => 'active',
          :features => features,
        })
        item_to_update.save  
#        raise(StandardError, item_to_update )
      end
      
    end

    message = {:notice => "catalog loaded"}
  end
  
  def check_item_params_before_update
    param_filtr = "cpanet_my_offer_program_item"
    if !params[param_filtr].blank?
      params[param_filtr]['features'] ||= {}
      
      if params[param_filtr]['features']['page_item'].blank?
        params[param_filtr]['features'] = params[param_filtr]['features'].except('page_item')
      else
        params[param_filtr]['features']['page_item'] = params[param_filtr]['features']['page_item'].to_i
      end       
      
      params[param_filtr]['features'] = params[param_filtr]['features'].except('page_item_name_for_check') if params[param_filtr]['features']['page_item_name_for_check'].blank?
      params[param_filtr]['features'] = params[param_filtr]['features'].except('source') if params[param_filtr]['features']['source'].blank?
      params[param_filtr]['features'] = params[param_filtr]['features'].except('content_name') if params[param_filtr]['features']['content_name'].blank?
      params[param_filtr]['features'] = params[param_filtr]['features'].except('content_desc') if params[param_filtr]['features']['content_desc'].blank?

      params[param_filtr]['features'] = params[param_filtr]['features'].except('is_for_yandex_rsy') if params[param_filtr]['features']['is_for_yandex_rsy'].blank?
      params[param_filtr]['features'] = params[param_filtr]['features'].except('use_yandex_adaptive_css_class') if params[param_filtr]['features']['use_yandex_adaptive_css_class'].blank?
      params[param_filtr]['features'] = params[param_filtr]['features'].except('rtb_id_small') if params[param_filtr]['features']['rtb_id_small'].blank?
      params[param_filtr]['features'] = params[param_filtr]['features'].except('rtb_id_middle') if params[param_filtr]['features']['rtb_id_middle'].blank?
      params[param_filtr]['features'] = params[param_filtr]['features'].except('rtb_id_big') if params[param_filtr]['features']['rtb_id_big'].blank?
      params[param_filtr]['features'] = params[param_filtr]['features'].except('stat_id') if params[param_filtr]['features']['stat_id'].blank?
    end
    
  end 
  
end
