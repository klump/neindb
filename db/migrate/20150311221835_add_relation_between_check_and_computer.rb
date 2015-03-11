class AddRelationBetweenCheckAndComputer < ActiveRecord::Migration
  def change
    add_column :checks, :computer_id, :integer
    add_foreign_key :checks, :computers, on_delete: :cascade
  end
end
