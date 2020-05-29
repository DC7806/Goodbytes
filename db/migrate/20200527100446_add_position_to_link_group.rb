class AddPositionToLinkGroup < ActiveRecord::Migration[6.0]
  def change
    add_column :link_groups, :position, :integer, default: 0
  end
end
