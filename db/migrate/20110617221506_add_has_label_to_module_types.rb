class AddHasLabelToModuleTypes < ActiveRecord::Migration
  def self.up
    add_column :module_types, :has_label, :boolean
  end

  def self.down
    remove_column :module_types, :has_label
  end
end
