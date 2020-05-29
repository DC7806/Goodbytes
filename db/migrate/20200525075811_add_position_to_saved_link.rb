class AddPositionToSavedLink < ActiveRecord::Migration[6.0]
  def change
    add_column :saved_links, :position, :integer, default: 0
  end
end
