class AddAPIKeyToCoreAffiliates < ActiveRecord::Migration[5.2]
  def change
    add_column :core_affiliates, :api_key, :string, after: :slug
  end
end
