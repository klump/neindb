class AddRelationBetweenStatusAndAsset < ActiveRecord::Migration
  def change
    add_column :statuses, :asset_id, :integer, null: false
    add_foreign_key :statuses, :assets, on_delete: :cascade
  end
end
