class Cpanet::MyOffer < ActiveRecord::Base
  belongs_to :website, :class_name =>'Cpanet::Website', :foreign_key => :website_id
  belongs_to :offer, :class_name =>'Cpanet::Offer', :foreign_key => :offer_id
  has_many :programs, :class_name =>'Cpanet::MyOffer::Program', :foreign_key => :program_id
  
  validates_presence_of [:website_id]
  
  store_accessor :features, :catalogs

  def offer_name
    offer.try(:name)
  end
  
  def offer_name_with_cpanet_name
    "#{offer.try(:name)}, #{website.try(:name)}"    
  end
  
  def self.synchronize_my_offers(website_id_to_update, my_offers_from_net)
    my_offers_from_net.each do |my_offer_from_net|
      next if my_offer_from_net['offer_id'].blank?
      
      Cpanet::MyOffer.find_or_create_by(:website_id => website_id_to_update, :offer_id => my_offer_from_net['offer_id'].try(:to_i)).update({
        :status => my_offer_from_net['connection_status'],
        :features => my_offer_from_net.except('offer_id', 'connection_status'),
      })
    end          
  end

  def self.synchronize_catalogs(my_offer_to_update, original_catalogs)
    if !my_offer_to_update.blank?
      if original_catalogs.is_a?(Array)
        catalogs = {}
        original_catalogs.each do |original_catalog|
          catalogs[original_catalog['yml_name']] = original_catalog
        end
      else
        catalogs = original_catalogs
      end
      
      my_offer_to_update.catalogs = catalogs
      my_offer_to_update.save
    end
  end

end

