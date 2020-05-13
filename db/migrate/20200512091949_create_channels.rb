class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
