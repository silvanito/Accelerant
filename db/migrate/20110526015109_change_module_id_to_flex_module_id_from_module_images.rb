class ChangeModuleIdToFlexModuleIdFromModuleImages < ActiveRecord::Migration
  def self.up
    rename_column :module_images, :module_id, :flex_module_id
  end

  def self.down
    rename_column :module_images, :flex_module_id, :module_id
  end
end
