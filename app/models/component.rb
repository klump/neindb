class Component < ActiveRecord::Base
  has_many :attached_components
  has_many :assets, through: :attached_components

  validates :name, presence: true, uniqueness: {scope: [:type]}
  validates :vendor, presence: true
  validates :type, presence: true
end
