class AddFtpFieldsToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :ftp_username, :string
    add_column :core_affiliates, :ftp_password, :string
	  remove_column :core_affiliates, :facebook_page, :string
    remove_column :core_users, :data1, :string
    remove_column :core_users, :data2, :string
  end
end
