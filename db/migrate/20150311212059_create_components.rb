class CreateComponents < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :components do |t|
      t.string :name
      t.string :vendor
      t.jsonb :properties, null: false, default: '{}'

      t.string :type

      t.timestamps null: false
    end
  end
end
