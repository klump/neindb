class AttachedComponent < ActiveRecord::Base
  belongs_to :computer
  belongs_to :component
end
