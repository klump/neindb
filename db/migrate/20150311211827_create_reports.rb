class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :status
      t.datetime :starttime
      t.datetime :endtime
      t.jsonb :data, null: false, default: '{}'

      t.timestamps null: false
    end
  end
end
