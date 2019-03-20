class AddResultTarifResults < ActiveRecord::Migration
  def change
    create_table :result_tarif_results do |t|
      t.references :run, index: true
      t.references :tarif, index: true
      t.string :part, index: true
      t.jsonb :result
    end
  end
end
