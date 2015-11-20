class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string "type", :limit => 25
      t.timestamps  
    end
  end
end
