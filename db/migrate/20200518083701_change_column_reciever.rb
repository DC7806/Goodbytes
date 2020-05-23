class ChangeColumnReciever < ActiveRecord::Migration[6.0]
  def change
    rename_column :invites, "reciever", "receiver"
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
