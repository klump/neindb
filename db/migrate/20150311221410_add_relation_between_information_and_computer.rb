class AddRelationBetweenInformationAndComputer < ActiveRecord::Migration
  def change
    add_column :information, :computer_id, :integer
    add_foreign_key :information, :computers, on_delete: :cascade
  end
end
