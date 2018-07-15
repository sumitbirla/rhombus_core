class AddFreeShippingToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :free_shipping, :boolean, null: false, default: false
  end
end
