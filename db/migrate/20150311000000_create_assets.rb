class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
      t.string :type
      t.jsonb :properties, null: false, default: '{}'

      t.timestamps null: false
    end
  end
end
