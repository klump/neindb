class Component < ActiveRecord::Base
  has_many :attached_components
  has_many :computers, through: :attaced_components
end
