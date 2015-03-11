class Cage < ActiveRecord::Base
  has_one :hard_drives, as: :hard_drive_attachable
end
