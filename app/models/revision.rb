class Revision < ActiveRecord::Base
  belongs_to :revisionable, polymorphic: true
  belongs_to :trigger, polymorphic: true

  # relations
  validates :trigger_id, presence: true
  validates :trigger_type, presence: true
  validates :revisionable_id, presence: true
  validates :revisionable_type, presence: true

  validates :data, presence: true
end
