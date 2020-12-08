class AddJsonDataToCoreLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :core_logs, :json_data, :json
  end
end
