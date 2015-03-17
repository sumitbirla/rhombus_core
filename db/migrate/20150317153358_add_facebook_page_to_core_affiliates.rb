class AddFacebookPageToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :facebook_page, :string
  end
end
