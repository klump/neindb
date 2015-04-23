class Report < ActiveRecord::Base
  STATUS = %w(running pass fail)

  has_many :revisions, as: :trigger
  belongs_to :asset

  validates :status, inclusion: STATUS, allow_nil: true
  validates :starttime, presence: true
end
