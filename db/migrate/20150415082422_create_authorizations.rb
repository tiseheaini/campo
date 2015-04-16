class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.integer :user_id
      t.string  :uid
      t.string  :access_token
      t.string  :provider

      t.timestamps
    end
  end
end
