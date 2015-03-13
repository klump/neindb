class Asset < ActiveRecord::Base
  has_many :statuses
  has_many :revisions, as: :revisionable
  has_many :attached_components
  has_many :components, through: :attached_components

  validates :name, presence: true, uniqueness: {scope: [:type]}
  validates :type, presence: true
end
