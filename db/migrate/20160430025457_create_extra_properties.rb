class CreateExtraProperties < ActiveRecord::Migration
  def change
    create_table :core_extra_properties do |t|
      t.integer :extra_property_id, null: false
      t.string :extra_property_type, null: false
      t.integer :sort, null: false, default: 1
      t.string :name, null: false
      t.string :value, null: false, length: 10000

      t.timestamps null: false
    end
  end
end
