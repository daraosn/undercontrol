class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.timestamps null: false

      t.integer :user_id, null:false
      t.string :api_key
      t.string :name
      t.string :description
      t.decimal :range_min, precision: 12, scale: 3, default: 0
      t.decimal :range_max, precision: 12, scale: 3, default: 100
      t.string :alarm_action, limit: 8 * 1024 # 8kb maximum JSON
      t.decimal :alarm_max, precision: 12, scale: 3, default: 0
      t.decimal :alarm_min, precision: 12, scale: 3, default: 0
      t.integer :alarm_threshold, default: 0
      t.boolean :alarm_triggered, default: false

      t.index :user_id
    end
  end
end
