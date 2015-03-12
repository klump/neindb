class AttachedComponent < ActiveRecord::Base
  belongs_to :asset
  belongs_to :component
end
