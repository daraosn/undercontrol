class UpdateApiKeyFromThings < ActiveRecord::Migration
  def change
    rename_column :things, :api_key, :old_api_key
  end
end
