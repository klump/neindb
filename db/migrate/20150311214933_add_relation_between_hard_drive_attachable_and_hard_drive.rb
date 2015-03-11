class AddRelationBetweenHardDriveAttachableAndHardDrive < ActiveRecord::Migration
  def change
    add_column :hard_drives, :hard_drive_attachable_id, :integer
    add_column :hard_drives, :hard_drive_attachable_type, :string
  end
end
