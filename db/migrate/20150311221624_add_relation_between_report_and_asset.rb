class AddRelationBetweenReportAndAsset < ActiveRecord::Migration
  def change
    add_column :reports, :asset_id, :integer
    add_foreign_key :reports, :assets, on_delete: :cascade
  end
end
