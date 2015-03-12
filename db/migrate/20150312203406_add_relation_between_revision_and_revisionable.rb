class AddRelationBetweenRevisionAndRevisionable < ActiveRecord::Migration
  def change
    add_column :revisions, :revisionable_id, :integer, null: false
    add_column :revisions, :revisionable_type, :string, null: false
  end
end
