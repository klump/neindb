require 'active_record/diff'

class Asset < ActiveRecord::Base
  include ActiveRecord::Diff
  
  diff include: [:serialized_components], exclude: [:created_at, :updated_at]

  has_many :statuses
  has_many :reports
  has_many :revisions, as: :revisionable
  has_many :attached_components
  has_many :components, through: :attached_components

  validates :name, presence: true, uniqueness: {scope: [:type]}
  validates :type, presence: true

  def Asset.changes_between(old, new)
    diff = old.diff(new)

    return if diff.empty?

    # rename serialized_components to components in the key if it exists
    diff[:components] = diff.delete(:serialized_components) if diff[:serialized_components]

    diff
  end

  def serialized_components
    components.map { |c| c.serializable_hash }
  end
end
