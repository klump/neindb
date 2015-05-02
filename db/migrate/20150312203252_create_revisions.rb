class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.json :data

      t.timestamps null: false
    end
  end
end
