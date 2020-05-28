class AddRoleToOrganizationsUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :organizations_users, :role, :string
  end
end
