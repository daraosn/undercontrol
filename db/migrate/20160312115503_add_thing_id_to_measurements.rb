class AddThingIdToMeasurements < ActiveRecord::Migration
  def change
    add_column :measurements, :thing_id, :integer

    add_index :measurements, :thing_id
  end
end
