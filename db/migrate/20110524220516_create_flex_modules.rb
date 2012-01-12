class CreateFlexModules < ActiveRecord::Migration
  def self.up
    create_table :flex_modules do |t|
      t.integer :module_type_id
      t.integer :discussion_id
      t.timestamps
    end
  end

  def self.down
    drop_table :flex_modules
  end
end
