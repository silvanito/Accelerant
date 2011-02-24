class AddUserToThemes < ActiveRecord::Migration
  def self.up
    add_column :themes, :user, :integer
  end

  def self.down
    remove_column :themes, :user
  end
end
