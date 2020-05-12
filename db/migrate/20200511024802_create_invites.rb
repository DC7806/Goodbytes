class CreateInvites < ActiveRecord::Migration[6.0]
  def change
    create_table :invites do |t|
      t.references :item, polymorphic: true, null: false
      t.string :token
      t.references :sender, null: false
      t.string :reciever, null: false

      t.timestamps
    end
  end
end
