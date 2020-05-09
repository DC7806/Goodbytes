class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.integer :payment, null: false, default: 0

      t.timestamps
    end
    
    add_index :organizations, :name, unique: true
  end
end
