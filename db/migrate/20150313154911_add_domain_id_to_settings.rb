class AddDomainIdToSettings < ActiveRecord::Migration
  def change
    add_column :core_settings, :domain_id, :integer, null: false
  end
end
