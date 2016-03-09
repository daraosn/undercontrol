class CreateUcSignalsMonitors < ActiveRecord::Migration
  def change
    create_table :uc_signals_monitors do |t|
      t.timestamps null: false

      t.integer :uc_signal_id
      t.integer :uc_monitor_id
    end
  end
end
