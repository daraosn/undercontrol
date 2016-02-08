class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.timestamps
      t.decimal :value, precision: 12, scale: 3
    end
  end
end
