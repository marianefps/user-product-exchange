class AddDefaultZeroToInventoryQuantity < ActiveRecord::Migration[6.0]
  def change
    change_column :inventories, :quantity, :integer, default: 0
  end
end
