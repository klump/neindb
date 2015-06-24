require 'active_record/diff'

class Status < ActiveRecord::Base
  include ActiveRecord::Diff
  
  diff exclude: [:message, :created_at, :updated_at]

  STATES = %w(ok warning critical unknown)

  has_many :revisions, as: :revisionable
  belongs_to :asset

  # relations
  validates :asset_id, presence: true

  validates :name, presence: true
  validates :state, presence: true, inclusion: STATES

  def Status.changes_between(old, new)
    diff = old.diff(new)

    return if diff.empty?

    diff
  end
end
