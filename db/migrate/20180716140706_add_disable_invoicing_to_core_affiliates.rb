class AddDisableInvoicingToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :disable_invoicing, :boolean, null: false, default: false
  end
end
