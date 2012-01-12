class AddDeletedToFlexModules < ActiveRecord::Migration
  def self.up
    add_column :flex_modules, :deleted, :integer
  end

  def self.down
    remove_column :flex_modules, :deleted
  end
end
