class CreateSavedLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :saved_links do |t|
      t.integer :link_group_id
      t.string :url
      t.string :subject
      t.text :summary

      t.timestamps
    end
  end
end
