class Report < ActiveRecord::Base
  has_many :revisions, as: :trigger
  belongs_to :computer
end
