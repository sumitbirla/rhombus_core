class AddTaxExemptToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :tax_exempt, :boolean, null: false, default: false
  end
end
