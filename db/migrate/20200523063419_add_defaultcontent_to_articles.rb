class AddDefaultcontentToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :header, :text
    add_column :articles, :footer, :text
    add_column :articles, :main_img, :text
  end
end
