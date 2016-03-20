class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.timestamps
      t.integer :thing_id
      t.decimal :value, precision: 12, scale: 3

      t.index :thing_id
    end
  end
end
