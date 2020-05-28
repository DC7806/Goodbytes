class CreateChannelsOrgUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :channels_org_users do |t|
      t.references :channel, null: false, foreign_key: true
      t.references :organizations_user, null: false, foreign_key: true
      t.string :role

      t.timestamps
    end
  end
end
