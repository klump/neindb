class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :name
      t.string :type
      t.json :properties

      t.timestamps null: false
    end
  end
end
