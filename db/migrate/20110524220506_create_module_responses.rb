class CreateModuleResponses < ActiveRecord::Migration
  def self.up
    create_table :module_responses do |t|
      t.integer :flex_module_id
      t.integer :user_id  
      t.timestamps
    end
  end

  def self.down
    drop_table :module_responses
  end
end
