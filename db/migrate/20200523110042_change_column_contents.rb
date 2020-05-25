class ChangeColumnContents < ActiveRecord::Migration[6.0]
  def change
   remove_column(:contents, :layout)
   add_column(:contents, :layout, :integer)
  end
end
