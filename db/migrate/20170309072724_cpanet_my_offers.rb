class CpanetMyOffers < ActiveRecord::Migration
  def change
    create_table :cpanet_my_offers do |t|
      t.references :website, index: true      
      t.references :offer, index: true      
      t.string :status, index: true
      t.jsonb :features
    end
    add_index :cpanet_my_offers, :features, using: :gin
  end
end
