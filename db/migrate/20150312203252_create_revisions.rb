class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.json :old_data
      t.json :new_data

      t.timestamps null: false
    end
  end
end
