class AddTaxIdToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :tax_id, :string
  end
end
