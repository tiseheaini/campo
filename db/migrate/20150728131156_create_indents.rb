class CreateIndents < ActiveRecord::Migration
  def change
    create_table :indents do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :count
      t.integer :address_id
      t.boolean :paymented
      t.boolean :trashed

      t.timestamps
    end
  end
end
