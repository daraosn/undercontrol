class CreateUcSensors < ActiveRecord::Migration
  def change
    create_table :uc_sensors do |t|
      t.string :name
      t.string :description
      t.string :kind

      t.integer :user_id

      t.timestamps null: false
    end
  end
end
