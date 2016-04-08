class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.integer :thing_id
      t.string :key

      t.timestamps null: false

      t.index :key
      t.index :thing_id
    end

    Thing.all.each do |thing|
      api_key = ApiKey.new thing_id: thing.id, key: thing.old_api_key
      api_key.save!
    end

    remove_column :things, :old_api_key
  end
end
