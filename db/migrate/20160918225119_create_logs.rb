class CreateLogs < ActiveRecord::Migration
  def change
    create_table :core_logs do |t|
      t.datetime :timestamp, null: false
      t.string :loggable_type, null: false
      t.integer :loggable_id, null: false
      t.integer :user_id
      t.string :ip_address, null: false
      t.string :event, null: false
      t.string :data1
      t.string :data2
      t.string :data3
    end
  end
end
