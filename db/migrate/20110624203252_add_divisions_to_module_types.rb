class AddDivisionsToModuleTypes < ActiveRecord::Migration
  def self.up
    add_column :module_types, :divisions, :integer
  end

  def self.down
    remove_column :module_types, :divisions
  end
end
