class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :name
      t.string :status
      t.string :message
      t.text :data

      t.timestamps null: false
    end
  end
end
