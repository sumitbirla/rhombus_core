class AddFieldsToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :purchase_order_email, :string
    add_column :core_affiliates, :invoice_email, :string
    add_column :core_affiliates, :shipment_email, :string
    remove_column :core_affiliates, :ftp_username, :string
    remove_column :core_affiliates, :ftp_password, :string
    remove_column :core_affiliates, :category_list, :text
    remove_column :core_affiliates, :price_formula, :string
  end
end
