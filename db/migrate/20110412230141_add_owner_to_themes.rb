class AddOwnerToThemes < ActiveRecord::Migration
  def self.up
    add_column :themes, :owner, :integer
  end

  def self.down
    remove_column :themes, :owner, :integer
  end
end
