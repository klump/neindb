class CreateHardDrives < ActiveRecord::Migration
  def change
    create_table :hard_drives do |t|
      t.string :serial
      t.string :model
      t.string :device_model
      t.string :firmware
      t.integer :capacity_bytes, limit: 8
      t.integer :rpm

      t.timestamps null: false
    end
  end
end
