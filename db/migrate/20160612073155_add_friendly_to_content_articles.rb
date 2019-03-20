class AddFriendlyToContentArticles < ActiveRecord::Migration
  def change
    change_table :content_articles do |t|
      t.string :slug
    end
    add_index :content_articles, :slug, unique: true
  end
end
