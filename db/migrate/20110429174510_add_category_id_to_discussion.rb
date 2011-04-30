class AddCategoryIdToDiscussion < ActiveRecord::Migration
  def self.up
    add_column :discussions, :category_id, :integer
  end

  def self.down
    remove_column :discussions, :category_id
  end
end
