class Status < ActiveRecord::Base
  STATES = %w(good warning critical unknown)

  has_many :revisions, as: :revisionable
  belongs_to :asset

  # relations
  validates :asset_id, presence: true

  validates :name, presence: true
  validates :state, presence: true, inclusion: STATES
end
