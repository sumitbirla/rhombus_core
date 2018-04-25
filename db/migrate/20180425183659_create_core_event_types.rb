class CreateCoreEventTypes < ActiveRecord::Migration
  def change
    create_table :core_event_types do |t|
      t.string :name, null: false
    end
  end
end
