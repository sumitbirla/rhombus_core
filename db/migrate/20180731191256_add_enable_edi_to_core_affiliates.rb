class AddEnableEdiToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :enable_edi, :boolean, null: false, default: false
  end
end
