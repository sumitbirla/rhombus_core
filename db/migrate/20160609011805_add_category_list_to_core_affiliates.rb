class AddCategoryListToCoreAffiliates < ActiveRecord::Migration
  def change
    add_column :core_affiliates, :category_list, :text
  end
end
