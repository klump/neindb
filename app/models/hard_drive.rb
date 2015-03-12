class HardDrive < ActiveRecord::Base
  has_many :revisions, as: :revisionable
  has_many :statuses, as: :status_trackable
  belongs_to :hard_drive_attachable, polymorphic: true
end
