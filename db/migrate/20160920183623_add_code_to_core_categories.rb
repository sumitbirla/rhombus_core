class AddCodeToCoreCategories < ActiveRecord::Migration
  def change
    add_column :core_categories, :code, :string, after: :hidden
	add_column :core_categories, :featured, :boolean, after: :hidden, null: false, default: false
	remove_column :core_categories, :desc3, :text
  end
end
