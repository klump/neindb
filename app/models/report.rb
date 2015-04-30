class Report < ActiveRecord::Base
  STATUS = %w(running pass fail)

  has_many :revisions, as: :trigger
  belongs_to :asset
  belongs_to :user

  validates :status, presence: true, inclusion: STATUS
  validates :starttime, presence: true
end
