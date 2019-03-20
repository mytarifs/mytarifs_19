class Cpanet::Offer < ActiveRecord::Base
  has_many :my_offers, :class_name =>'Cpanet::MyOffer', :foreign_key => :offer_id

  def self.synchronize_offer(cpanet_to_update, offer_id_to_update, offer_from_net)
    Cpanet::Offer.find_or_create_by(:id => offer_id_to_update).update({
      :name => offer_from_net['name'],
      :cpanet => cpanet_to_update,
      :status => offer_from_net['status'],
      :features => offer_from_net.except('id', 'name', 'status'),
    })
  end

end

