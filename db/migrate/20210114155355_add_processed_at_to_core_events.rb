class AddProcessedAtToCoreEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :core_events, :processed_at, :datetime
  end
end
