class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :status
      t.datetime :starttime
      t.datetime :endtime
      t.text :log
      t.json :data

      t.timestamps null: false
    end
  end
end
