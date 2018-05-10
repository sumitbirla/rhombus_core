class AddDiscountFieldsToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :discount_percent, :decimal, precision: 5, scale: 2, null: false, default: 0.0
    add_column :core_affiliates, :markup_percent, :decimal, precision: 5, scale: 2, null: false, default: 0.0
  end
end
