class ChangeModuleIdToFlexModuleIdFromModuleResponses < ActiveRecord::Migration
  def self.up
    rename_column :module_responses, :module_id, :flex_module_id
  end

  def self.down
    rename_column :module_responses, :flex_module_id, :module_id
  end
end
