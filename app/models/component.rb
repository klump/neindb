class Component < ActiveRecord::Base
  has_many :attached_components
  has_many :assets, through: :attached_components
end
