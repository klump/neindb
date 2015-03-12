class Status < ActiveRecord::Base
  has_many :revsions, as: :revisionable
  belongs_to :status_trackable, polymorphic: true
end
