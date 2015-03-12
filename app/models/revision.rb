class Revision < ActiveRecord::Base
  belongs_to :revisionable, polymorphic: true
  belongs_to :trigger, polymorphic: true
end
