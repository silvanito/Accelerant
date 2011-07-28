class AddInstructionsToFlexModules < ActiveRecord::Migration
  def self.up
    add_column :flex_modules, :instructions, :string
  end

  def self.down
    remove_column :flex_modules, :instructions
  end
end
