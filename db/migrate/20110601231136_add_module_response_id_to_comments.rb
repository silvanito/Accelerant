class AddModuleResponseIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :module_response_id, :integer
  end

  def self.down
    remove_column :comments, :module_response_id
  end
end
