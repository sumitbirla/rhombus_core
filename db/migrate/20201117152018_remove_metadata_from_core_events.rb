class RemoveMetadataFromCoreEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :core_events, :metadata, :string
  end
end
