class CpanetWebsites < ActiveRecord::Migration
  def change
    create_table :cpanet_websites do |t|
#      t.integer :id, index: true
      t.string :name
      t.string :cpanet, index: true
      t.string :status, index: true
      t.jsonb :features
    end
    add_index :cpanet_websites, :features, using: :gin
  end
end
