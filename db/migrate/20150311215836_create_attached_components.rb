class CreateAttachedComponents < ActiveRecord::Migration
  def change
    create_table :attached_components do |t|
      t.string :connector

      t.timestamps null: false
    end
  end
end
