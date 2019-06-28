class AddTransactionFeeToCoreAffiliates < ActiveRecord::Migration[5.2]
  def change
    add_column :core_affiliates, :transaction_fee, :decimal, null: false, default: 0.0, after: :tax_exempt, precision: 5, scale: 2
    remove_column :core_affiliates, :purchase_order_email
    remove_column :core_affiliates, :invoice_email
    remove_column :core_affiliates, :shipment_email
  end
end
