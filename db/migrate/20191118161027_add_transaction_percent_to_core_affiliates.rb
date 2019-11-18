class AddTransactionPercentToCoreAffiliates < ActiveRecord::Migration[5.2]
  def change
    add_column :core_affiliates, :transaction_percent, :decimal, precision: 5, scale: 2, null: false, default: 0.0
    add_column :core_affiliates, :requires_approval, :boolean, null: false, default: false
  end
end
