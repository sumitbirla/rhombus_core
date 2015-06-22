class AddDataFieldsToCoreUsers < ActiveRecord::Migration
  def change
    add_column :core_users, :data1, :string
    add_column :core_users, :data2, :string
  end
end
