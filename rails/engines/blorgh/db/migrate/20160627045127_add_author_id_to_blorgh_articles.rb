class AddAuthorIdToBlorghArticles < ActiveRecord::Migration
  def change
    add_column :blorgh_articles, :author_id, :integer
  end
end
