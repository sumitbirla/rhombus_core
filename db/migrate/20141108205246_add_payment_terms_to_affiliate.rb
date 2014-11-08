class AddPaymentTermsToAffiliate < ActiveRecord::Migration
  def change
	add_column :core_affiliates, :payment_terms, :string
  end
end
