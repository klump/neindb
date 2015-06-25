class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.jsonb :data, null: false, default: '{}'

      t.timestamps null: false
    end
  end
end
