require 'active_record/diff'

class Asset < ActiveRecord::Base
  include ActiveRecord::Diff
  
  diff include: [:serialized_components]

  has_many :statuses
  has_many :revisions, as: :revisionable
  has_many :attached_components
  has_many :components, through: :attached_components

  validates :name, presence: true, uniqueness: {scope: [:type]}
  validates :type, presence: true

  def serialized_components
    components.map { |c| c.serializable_hash }
  end
end
