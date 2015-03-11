class AddRelationBetweenComponentAndComputerThroughAttachedComponents < ActiveRecord::Migration
  def change
    add_column :attached_components, :computer_id, :integer
    add_foreign_key :attached_components, :computers, on_delete: :cascade
    add_column :attached_components, :component_id, :integer
    add_foreign_key :attached_components, :components, on_delete: :cascade
  end
end
