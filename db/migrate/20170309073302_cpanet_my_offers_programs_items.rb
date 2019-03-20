class CpanetMyOffersProgramsItems < ActiveRecord::Migration
  def change
    create_table :cpanet_my_offer_program_items do |t|
#      t.integer :id, index: true
      t.string :name
      t.references :program, index: true      
      t.string :status, index: true
      t.jsonb :features
    end
    add_index :cpanet_my_offer_program_items, :features, using: :gin
  end
end
