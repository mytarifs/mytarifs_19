class Cpanet::WebsitesController < ApplicationController
  include Cpanet::WebsitesHelper
  helper Cpanet::WebsitesHelper

  def synchronize
    result = synchronize_websites
    
    redirect_to cpanet_websites_path, result
  end

end
