class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.integer :channel_id
      t.string :subject
      t.datetime :deliver_time

      t.timestamps
    end
  end
end
