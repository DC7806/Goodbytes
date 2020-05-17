class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.integer :channel_id, null: false
      t.string :subject, null: false
      t.datetime :deliver_time

      t.timestamps
    end

    add_foreign_key :articles, :channels
    add_index :articles, :channel_id
  end
end
