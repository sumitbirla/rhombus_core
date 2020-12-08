class AddFieldsToCoreEvents < ActiveRecord::Migration[5.2]
  def change
    # add_column :core_events, :user_id, :integer, after: :event_type_id
    # add_column :core_events, :affiliate_id, :integer, after: :event_type_id
    add_column :core_events, :json_data, :string, after: :expires
  end
end
