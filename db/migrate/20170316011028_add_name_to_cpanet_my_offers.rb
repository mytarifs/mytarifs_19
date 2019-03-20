class AddNameToCpanetMyOffers < ActiveRecord::Migration
  def change
    change_table :cpanet_my_offers do |t|
      t.string :name
    end
  end
end
