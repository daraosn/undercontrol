class CreateUcSignals < ActiveRecord::Migration
  def change
    create_table :uc_signals do |t|
      t.timestamps null: false

      t.string :unit

      t.integer :uc_sensor_id
      t.index :uc_sensor_id

    end
  end
end
