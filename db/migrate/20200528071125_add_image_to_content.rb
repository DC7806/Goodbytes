class AddImageToContent < ActiveRecord::Migration[6.0]
  def change
    add_column :contents, :image, :string
  end
end
