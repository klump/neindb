class Report < ActiveRecord::Base
  STATUS = %w(running success failure)
  WORKER_STATUS = %w(parsing sucess failure)

  has_many :revisions, as: :trigger
  belongs_to :asset
  belongs_to :user

  validates :status, presence: true, inclusion: STATUS
  validates :worker_status, inclusion: WORKER_STATUS, allow_nil: true
  validates :starttime, presence: true
end
