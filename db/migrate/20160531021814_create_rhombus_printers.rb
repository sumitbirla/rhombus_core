class CreateRhombusPrinters < ActiveRecord::Migration
  def change
    create_table :core_printers do |t|
      t.string :name, null: false
      t.string :url, null: false
      t.integer :print_count, null: false, default: 0
      t.string :location, null: false

      t.timestamps null: false
    end
  end
end
