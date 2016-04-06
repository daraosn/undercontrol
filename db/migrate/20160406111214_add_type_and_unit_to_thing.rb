class AddTypeAndUnitToThing < ActiveRecord::Migration
  def change
    add_column :things, :sensor_type, :string
    add_column :things, :unit, :string
  end
end
