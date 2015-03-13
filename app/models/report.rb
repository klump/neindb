class Report < ActiveRecord::Base
  STATUS = %w(pass fail)

  has_many :revisions, as: :trigger
  belongs_to :asset

  # relations
  validates :asset_id, presence: true

  validates :status, presence: true, inclusion: STATUS
  validates :starttime, presence: true
  validates :endtime, presence: true
  validates :data, presence: true
end
