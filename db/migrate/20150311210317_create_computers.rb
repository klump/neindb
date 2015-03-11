class CreateComputers < ActiveRecord::Migration
  def change
    create_table :computers do |t|
      t.string :serial
      t.string :location
      t.integer :dimm_slots
      t.integer :pci_slots
      t.string :bios_vendor
      t.string :bios_version
      t.string :vendor
      t.string :product_name

      t.timestamps null: false
    end
  end
end
