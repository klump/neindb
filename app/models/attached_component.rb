class AttachedComponent < ActiveRecord::Base
  belongs_to :asset
  belongs_to :component

  # relations
  validates :asset_id, presence: true
  validates :component_id, presence: true
end
