class AddDescriptionToCoreEventTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :core_event_types, :description, :string
  end
end
