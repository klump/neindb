class AddRelationBetweenComponentAndAssetThroughAttachedComponents < ActiveRecord::Migration
  def change
    add_column :attached_components, :asset_id, :integer
    add_foreign_key :attached_components, :assets, on_delete: :cascade
    add_column :attached_components, :component_id, :integer
    add_foreign_key :attached_components, :components, on_delete: :cascade
  end
end
