class AddProjectIdToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :project_id, :integer
  end

  def self.down
    remove_column :categories, :project_id
  end
end
