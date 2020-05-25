class CreateContents < ActiveRecord::Migration[6.0]
  def change
    create_table :contents do |t|
      t.integer :article_id#, null: false
      t.text :layout#, null: false
      t.integer :position #, #null: false, default: 0 
      t.text :title
      t.text :desc
      t.text :url

      t.timestamps
    end
  end
end
