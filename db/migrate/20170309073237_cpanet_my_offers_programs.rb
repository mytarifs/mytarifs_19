class CpanetMyOffersPrograms < ActiveRecord::Migration
  def change
    create_table :cpanet_my_offer_programs do |t|
      t.string :name
      t.references :my_offer, index: true      
      t.string :status, index: true
      t.jsonb :features
    end
    add_index :cpanet_my_offer_programs, :features, using: :gin
  end
end
