class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.timestamps
      t.integer :value
    end
  end
end
