class Component < ActiveRecord::Base
  has_many :attached_components
  has_many :assets, through: :attached_components

  validates :name, presence: true, uniqueness: {scope: [:type]}, unless: :not_identified_by_name?
  validates :vendor, presence: true
  validates :type, presence: true

  def not_identified_by_name
    !([Component::Nic].include?(type))
  end
end
