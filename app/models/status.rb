class Status < ActiveRecord::Base
  has_many :revisions, as: :revisionable
  belongs_to :asset
end
