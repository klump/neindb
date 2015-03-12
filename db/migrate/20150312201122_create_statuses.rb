class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name
      t.string :state
      t.string :message

      t.timestamps null: false
    end
  end
end
