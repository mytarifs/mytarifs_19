class Cpanet::Website < ActiveRecord::Base
  Nets = {
    :admitad => {:my_domens => ['ap.mytarifs.ru']},
    :actionpay => {:my_domens => ['adms.mytarifs.ru', 'admy.mytarifs.ru']},
    :mytarifs => {:my_domens => []},
  } 
   
  has_many :my_offers, :class_name =>'Cpanet::MyOffer', :foreign_key => :website_id
  
  def name_with_cpanet
    "#{cpanet}, #{name}"
  end
  
  def self.synchronize_websites(cpanet_to_update, websites_from_net)
    websites_from_net.each do |website_from_net|
      next if website_from_net['id'].blank?
      
      Cpanet::Website.find_or_create_by(:id => website_from_net['id'].try(:to_i)).update({
        :name => website_from_net['name'],
        :cpanet => cpanet_to_update,
        :status => website_from_net['status'],
        :features => website_from_net.except('id', 'name', 'status'),
      })
    end          
  end

end

