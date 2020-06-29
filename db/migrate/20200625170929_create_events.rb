class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :core_events do |t|
      t.integer :event_type_id, null: false
      t.datetime :expires, null: false
      t.text :metadata

      t.timestamps
    end
  end
end
