class CreateUcMeasurements < ActiveRecord::Migration
  def change
    create_table :uc_measurements do |t|
      t.timestamps null: false

      t.decimal :value, precision: 12, scale: 3

      t.integer :uc_signal_id

      t.index :uc_signal_id
    end
  end
end
