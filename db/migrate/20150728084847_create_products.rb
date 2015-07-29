class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :user_id
      t.float   :price
      t.string  :name
      t.boolean :trashed

      t.timestamps
    end
  end
end
