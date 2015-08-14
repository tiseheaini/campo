class CreateItemAttrs < ActiveRecord::Migration
  def change
    create_table :item_attrs do |t|
      t.integer :product_id
      t.string  :name
      t.float   :price
      t.boolean :trashed, default: false

      t.timestamps
    end
  end
end
