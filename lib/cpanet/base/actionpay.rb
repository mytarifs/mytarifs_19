module Cpanet
  class Base::Actionpay < Base
    base_uri 'api.actionpay.net/ru-ru'
    
    Default = {
      :connection => {
      },
      :param_matches => {
        :website_id => :source,
        :offer_id => :offer,
      },
      :commands => {
        :websites => {:command_type => :get, :path => "/apiWmSources/", :params => [:format, :active]},
        :my_offers => {:command_type => :get, :path => "/apiWmMyOffers/", :params => [:format]},
        :offer => {:command_type => :get, :path => "/apiWmOffers/", :params => [:format, :category, :offer, :page, :timestamp]},
        :landings => {:command_type => :get, :path => "/apiWmLandings/", :params => [:format, :offer]},
        :catalogs => {:command_type => :get, :path => "/apiWmYmls/", :params => [:format, :offer]},
        :catalog_with_deeplinks => {:command_type => :get, :path => "/apiWmYmls/", :params => [:format, :act, :yml, :source, :domain]},
      },
      :result_key => 'result',
      :result => {
        :websites => {:result_type => :array, :result_sub_key => 'sources', 
          :keys => {"id" => 'id', "name" => 'name', 'status' => {"name" => 'status'}}, :keys_to_skip_process => [] },
        :my_offers => {:result_type => :array, :result_sub_key => 'favouriteOffers', 
          :keys => {"offer" => {"id" => 'offer_id', 'name' => 'name', 'status' => {"name" => 'offer_status'} }, 'status' => {"name" => 'connection_status'} }, :keys_to_skip_process => [] },
        :offer => {:result_type => :array, :result_sub_key => 'offers', 
          :keys => {"id" => 'id', 'name' => 'name', 'status' => {"name" => 'status'} }, :keys_to_skip_process => [] },
        :landings => {:result_type => :array, :result_sub_key => 'landings', 
          :keys => {"id" => 'id', 'name' => 'name', 'url' => 'gotolink' }, :keys_to_skip_process => [] },
        :catalogs => {:result_type => :array, :result_sub_key => 'offers', :result_sub_array_key => 'ymls',
          :keys => {
            'id' => 'offer_id', 'name' => 'offer_name', 'deeplinks' => 'has_deeplinks', 'ymls' => {
              'id' => 'yml_id', 'name' => 'yml_name',
              'file' => {'url' => 'file_url', 'size' => 'file_size'},
            },
          }, :keys_to_skip_process => [] },
      },
      :param_options => {
        :website_statuses => ['active', 'disabled'],
        :my_offer_statuses => ['pending', 'active', 'declined', 'disabled'],
#        :status => ['new', 'pending', 'active', 'suspended', 'declined'],
#        :connection_status => ['active', 'pending', 'declined'],
#        :has_tool => ['deeplink', 'products', 'retag', 'arecord', 'call_tracking', 'postview', 'lost_orders']
      },
    }
    
    def deeplinks
      file_url = generate_url_params(:catalog_with_deeplinks).join('?')
      options[:file_url] = file_url
      parsed_catalog
    end

    def error(result = {})
      return nil if result.try(:[], 'error').blank?
      {
        'error' =>  {"description" => result['error'].try(:[], 'text'), "code" => result['error'].try(:[], 'code') }
      }      
    end
    
    def auth_options(scope = [])
      {:query => {:key => "#{ENV['ACTIONPAY_KEY']}"}  }
    end

    def default
      Base::Actionpay::Default
    end
    
  end
  
end