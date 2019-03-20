module Cpanet
  class Base::Admitad < Base
    base_uri 'api.admitad.com'
    
    Default = {
      :connection => {
        :content_type => 'application/x-www-form-urlencoded',
        :charset => 'UTF-8',
      },
      :param_matches => {
        :website_id => :website_id,
        :offer_id => :offer_id,
      },
      :commands => {
        :token => {:command_type => :post, :path => "/token/"},
        :websites => {:command_type => :get, :path => "/websites/", :params => [:offset, :limit, :status, :campaign_status], :scope => ['websites']},
        :my_offers => {:command_type => :get, :path => "/advcampaigns/website/{website_id}/", :params => [:offset, :limit, :connection_status, :has_tool], :scope => ['advcampaigns_for_website']},
        :offer => {:command_type => :get, :path => "/advcampaigns/{offer_id}/website/{website_id}/", :params => [], :scope => ['advcampaigns_for_website']},
        :landings => {:command_type => :get, :path => "/landings/{offer_id}/website/{website_id}/", :params => [], :scope => ['landings']},
        :catalogs => {:command_type => :get, :path => "/advcampaigns/{offer_id}/website/{website_id}/", :params => [], :scope => ['advcampaigns_for_website']},
      },
      :result_key => 'results',
      :result => {
        :websites => {:result_type => :array, 
          :keys => {"id" => 'id', "name" => 'name', 'status' => 'status'}, :keys_to_skip_process => [] },
        :my_offers => {:result_type => :array, 
          :keys => {"id" => 'offer_id', "name" => 'name', 'status' => 'offer_status', 'connection_status' => 'connection_status'}, :keys_to_skip_process => [] },
        :offer => {:result_type => :item, :without_main_result_key => true, 
          :keys => {"id" => 'id', "name" => 'name', 'status' => 'status' }, :keys_to_skip_process => [] }, #, 'gotolink' => 'gotolink'
        :landings => {:result_type => :array, 
          :keys => {"id" => 'id', "name" => 'name', 'gotolink' => 'gotolink', 'date_created' => 'date_created'}, :keys_to_skip_process => [] },
        :catalogs => {:result_type => :item, :without_main_result_key => true, :result_sub_array_key => 'feeds_info', 
          :keys => {"id" => 'offer_id', "name" => 'offer_name', 'allow_deeplink' => 'has_deeplinks', 'feeds_info' => {
              'name' => 'yml_name', 'xml_link' => 'file_url', 'admitad_last_update' => 'net_last_update', 'advertiser_last_update' => 'advertiser_last_update'
            },
          }, :keys_to_skip_process => [
              "goto_cookie_lifetime", "rating", "exclusive", "image", "actions", "products_xml_link", "currency", "activation_date", "cr", 
              "max_hold_time", "id", "avg_hold_time", "ecpc", "connection_status", "gotolink", "site_url", "regions", "actions_detail", 
              "geotargeting", "status", "coupon_iframe_denied", "traffics", "description", "cr_trend", "raw_description", "modified_date", 
              "denynewwms", "moderation", "categories", "products_csv_link", "retag", "name", "landing_code", "ecpc_trend", "landing_title", "show_products_links"                         
          ] }, #, 'gotolink' => 'gotolink'
      },
      :param_options => {
        :website_statuses => ['active', 'disabled'],
        :my_offer_statuses => ['pending', 'active', 'declined', 'disabled'],
#        :status => ['new', 'pending', 'active', 'suspended', 'declined'],
#        :connection_status => ['active', 'pending', 'declined'],
#        :has_tool => ['deeplink', 'products', 'retag', 'arecord', 'call_tracking', 'postview', 'lost_orders']
      },
    }

    def error(result = {})
      return nil if result.try(:[], 'error').blank?
      {
        'error' =>  {"description" => "#{result['error']}, #{result['error_description']}", "code" => result['error_code'] }
      }
    end
    
    def auth_options(scope = [])
      token_keys = token(scope)
      token_keys.try(:[], 'error').blank? ? {:headers => {'Authorization' => "#{token_keys['token_type']} #{token_keys['access_token']}"}  } : {}
    end

    def token(scope)
      path = default[:commands][:token][:path]
      params = base_options.deep_merge({
        :headers => {
          'Authorization' => "Basic #{ENV['ADMITAD_KEY']}"
        },
        :query => {:grant_type => 'client_credentials', :client_id => ENV['ADMITAD_CLIENT_ID'], :scope => scope.join(' ')}
      })
 
      result = self.class.post(path, params)
    end
    
    def base_options
      {
        :headers => {
          'Content-Type' => default[:connection][:content_type],
          'charset' => default[:connection][:charset],
        }
      }
      
    end
    
    def default
      Base::Admitad::Default
    end
    
  end
  
end