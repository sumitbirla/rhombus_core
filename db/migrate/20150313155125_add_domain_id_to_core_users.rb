class AddDomainIdToCoreUsers < ActiveRecord::Migration
  def change
    add_column :core_users, :domain_id, :integer, null: false
  end
end
