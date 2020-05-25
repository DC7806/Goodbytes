class AddDeletedAtToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :deleted_at, :datetime
    add_index :articles, :deleted_at
    add_column :contents, :deleted_at, :datetime
    add_index :contents, :deleted_at
  end
end
