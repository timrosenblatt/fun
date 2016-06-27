# This migration comes from blorgh (originally 20160626222929)
class CreateBlorghArticles < ActiveRecord::Migration
  def change
    create_table :blorgh_articles do |t|
      t.string :title
      t.text :text

      t.timestamps null: false
    end
  end
end
