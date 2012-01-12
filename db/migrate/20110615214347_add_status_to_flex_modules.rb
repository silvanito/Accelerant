class AddStatusToFlexModules < ActiveRecord::Migration
  def self.up
    add_column :flex_modules, :status, :string
  end

  def self.down
    remove_column :flex_modules, :status
  end
end
