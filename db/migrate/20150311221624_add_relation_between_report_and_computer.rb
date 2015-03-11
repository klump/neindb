class AddRelationBetweenReportAndComputer < ActiveRecord::Migration
  def change
    add_column :reports, :computer_id, :integer
    add_foreign_key :reports, :computers, on_delete: :cascade
  end
end
