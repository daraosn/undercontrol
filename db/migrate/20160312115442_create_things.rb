class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.timestamps null: false

      t.integer :user_id, null:false
      t.string :api_key
      t.string :name
      t.string :description
      t.decimal :range_min
      t.decimal :range_max
      t.string :alarm_action
      t.decimal :alarm_max
      t.decimal :alarm_min
      t.integer :alarm_threshold
      t.boolean :alarm_triggered, default: false

      t.index :user_id
    end
  end
end
