class RemoveLowerColumn < ActiveRecord::Migration
  def change
    remove_column :users, :username_lower
    remove_column :users, :email_lower
    remove_index :users, :username
    remove_index :users, :email
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true

    remove_column :categories, :slug_lower
    remove_index :categories, :slug
    add_index :categories, :slug, unique: true
  end
end
