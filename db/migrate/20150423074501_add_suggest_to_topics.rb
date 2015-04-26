class AddSuggestToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :suggest, :boolean, after: :hot, default: false
  end
end
