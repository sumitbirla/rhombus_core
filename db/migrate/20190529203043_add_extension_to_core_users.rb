class AddExtensionToCoreUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :core_users, :extension, :string, after: :phone
  end
end
