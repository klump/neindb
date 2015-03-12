class AddRelationBetweenRevisionAndTrigger < ActiveRecord::Migration
  def change
    add_column :revisions, :trigger_id, :integer, null: false
    add_column :revisions, :trigger_type, :string, null: false
  end
end
