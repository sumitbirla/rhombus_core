class AddExternalIdToCoreUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :core_users, :external_id, :string, after: :id
  end
end
