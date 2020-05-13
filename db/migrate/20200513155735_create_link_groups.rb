class CreateLinkGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :link_groups do |t|
      t.integer :channel_id
      t.string :name

      t.timestamps
    end
  end
end
