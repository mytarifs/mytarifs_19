class ChangeIndexesInContentArticle < ActiveRecord::Migration
  def up
    execute <<-SQL
      DROP INDEX index_content_articles_on_key_operators;
      DROP INDEX index_content_articles_on_key_roumings;
      DROP INDEX index_content_articles_on_key_services;
      DROP INDEX index_content_articles_on_key_destinations;
      DROP INDEX index_content_articles_on_key_intensities;
      
      CREATE INDEX index_content_articles_on_key_operator_id ON content_articles ( (key->>'operator_id') );
      CREATE INDEX index_content_articles_on_key_tarif_id ON content_articles ( (key->>'tarif_id') );
    SQL
  end

  def down
    execute <<-SQL
      CREATE INDEX index_content_articles_on_key_operators ON content_articles ( (key->>'operators') );
      CREATE INDEX index_content_articles_on_key_roumings ON content_articles ( (key->>'roumings') );
      CREATE INDEX index_content_articles_on_key_services ON content_articles ( (key->>'services') );
      CREATE INDEX index_content_articles_on_key_destinations ON content_articles ( (key->>'destinations') );
      CREATE INDEX index_content_articles_on_key_intensities ON content_articles ( (key->>'intensities') );
      
      DROP INDEX index_content_articles_on_key_operator_id;
      DROP INDEX index_content_articles_on_key_tarif_id;
    SQL
  end
  

end
