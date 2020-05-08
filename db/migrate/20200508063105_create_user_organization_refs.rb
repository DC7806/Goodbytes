class CreateUserOrganizationRefs < ActiveRecord::Migration[6.0]
  def change
    create_table :user_organization_refs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
