class HardDrive < ActiveRecord::Base
  belongs_to :hard_drive_attachable, polymorphic: true
end
