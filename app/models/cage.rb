class Cage < ActiveRecord::Base
  has_one :hard_drive, as: :hard_drive_attachable
end
