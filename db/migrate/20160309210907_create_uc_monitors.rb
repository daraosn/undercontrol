class CreateUcMonitors < ActiveRecord::Migration
  def change
    create_table :uc_monitors do |t|
      t.timestamps null: false

      t.integer :user_id

      t.string :name
      t.string :kind
    end
  end
end
