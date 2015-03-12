class Computer < ActiveRecord::Base
  has_many :reports
  has_many :attached_components
  has_many :components, through: :attached_components
  has_many :hard_drives, as: :hard_drive_attachable
  has_many :revisions, as: :revisionable
  has_many :statuses, as: :status_trackable
end
