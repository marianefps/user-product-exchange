class CreateInventories < ActiveRecord::Migration[6.0]
  def change
    create_table :inventories do |t|
      t.string :product
      t.integer :quantity
      t.references :user, index: true, foreign_key: true
      t.index [:user_id, :product], unique: true
      t.timestamps
    end
  end
end
