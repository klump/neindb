class CreateComponents < ActiveRecord::Migration
  def change
    enable_extension 'hstore' unless extension_enabled?('hstore')
    create_table :components do |t|
      t.string :type
      t.hstore :attributes

      t.timestamps null: false
    end
  end
end
